require 'securerandom'

class Vdebug
  class BufferNotFound < StandardError; end;

  attr_reader :vim, :watch_win_marker

  def initialize(vim)
    @lock_file = "../vdebug.lock"
    @instance_id = SecureRandom::hex(3)
    @vim = vim
    @watch_win_marker = option_value("marker_default")
  end

  def start_listening
    write_lock_file!
    clear_buffer_cache!
    if ENV["DEBUG"]
      set_opt "debug_file_level", 2
      set_opt "debug_file", "/tmp/vdebug.log"
    end
    set_opt "background_listener", 0
    vim.server.remote_send ":python3 debugger.run()<CR>"
    sleep 2
  end

  def set_opt(name, value)
    vim.command "VdebugOpt #{name} #{value}"
  end

  def messages
    vim.command("messages")
  end

  def last_error
    vim.command("python3 debugger.get_last_error()")
  end

  def step_to_line(number)
    vim.command "#{number}"
    vim.command "python3 debugger.run_to_cursor()"
  end

  def step_over
    vim.command 'python3 debugger.step_over()'
  end

  def step_in
    vim.command 'python3 debugger.step_into()'
  end

  def trace(expression)
    evaluate(expression, "VdebugTrace")
  end

  def evaluate(expression = "", command = "VdebugEval")
    safe_expression = expression.gsub(/['"\\\x0]/,'\\\\\0')
    vim.command "#{command} #{safe_expression}"
  end

  def evaluate!(expression)
    evaluate(expression, "VdebugEval!")
  end

  # Retrieve a hash with the buffer names (values) and numbers (keys)
  def buffers
    @buffers ||= fetch_buffers
  end

  # Do this when you want to refresh the buffer list
  def clear_buffer_cache!
    @buffers = nil
  end

  # Has the vdebug GUI been opened?
  def gui_open?
    names = buffers.values
    %w[DebuggerStack DebuggerStatus DebuggerWatch].all? { |b|
      names.include? b
    }
  end

  def running?
    gui_open? && connected?
  end

  def connected?
     status = vim.command(
       "python3 print debugger.status()"
     )
     %w(break running).include? status
  end

  def watch_window_content
    fetch_buffer_content 'DebuggerWatch'
  end

  def watch_vars
    watch_lines = watch_window_content.split("\n")[4..-1]
    Hash[watch_lines.join("").split('|').map { |v|
      v.gsub(/^.*#{watch_win_marker}/, "").split("=", 2).map(&:strip)
    }]
  end

  def stack_window_content
    fetch_buffer_content 'DebuggerStack'
  end

  def trace_window_content
    clear_buffer_cache!
    fetch_buffer_content 'DebuggerTrace'
  end

  def stack
    stack_window_content.split("\n").map { |l|
      s = {}
      matches = /^\[(\d+)\] (\S+) @ ([^:]+):(\d+)/.match(l)
      if matches
        s[:level] = matches[1]
        s[:name] = matches[2]
        s[:file] = matches[3]
        s[:line] = matches[4]
        s
      else
        raise "Invalid stack line: #{l}"
      end
    }
  end

  def status_window_content
    fetch_buffer_content 'DebuggerStatus'
  end

  def status
    /Status: (\S+)/.match(status_window_content)[1]
  end

  def remove_lock_file!
    if File.exists?(@lock_file)
      lock_file_id = File.read(@lock_file)
      if lock_file_id == @instance_id
        puts "Releasing lock (#{@instance_id})"
        File.delete(@lock_file)
      else
        puts "Lock file #{@lock_file} is for instance #{lock_file_id}, whereas current instance is #{@instance_id}"
      end
    end
  end

protected
  def write_lock_file!
    if File.exists?(@lock_file)

      puts "Waiting for vdebug lock to be released"
      i = 0
      while File.exists?(@lock_file)
        sleep 0.5
        i += 1
        raise "Failed to acquire vdebug lock" if i >= 20
      end
    end
    puts "Acquiring vdebug lock (#{@instance_id})"
    File.write(@lock_file, @instance_id)
  end

  def fetch_buffer_content(name)
    bufnum = buffers.invert.fetch(name)
    vim.echo(%Q{join(getbufline(#{bufnum}, 1, "$"), "\\n")})
  rescue KeyError
    raise BufferNotFound, "#{name} buffer not found"
  end

  def fetch_buffers
    buffer_string = vim.command('buffers')
    names = buffer_string.split("\n").collect do |bufline|
      matches = /\A\s*(\d+).*"([^"]+)"/.match(bufline)
      [matches[1].to_i, matches[2]] if matches
    end
    Hash[names.compact]
  end

  def option_value(name)
    vim.echo("g:vdebug_options['#{name}']")
  end
end
