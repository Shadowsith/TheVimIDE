from __future__ import print_function

import os
import sys
import time

from . import error


class Logger(object):
    """ Abstract class for all logger implementations.

    Concrete classes will log messages using various methods,
    e.g. write to a file.
    """

    (ERROR, INFO, DEBUG) = (0, 1, 2)
    TYPES = ("ERROR", "Info", "Debug")
    debug_level = ERROR

    def __init__(self, debug_level):
        self.debug_level = int(debug_level)

    def log(self, string, level):
        """ Log a message """
        if level > self.debug_level:
            return
        self._actual_log(string, level)

    def _actual_log(self, string, level):
        """ Actually perform the logging (to be implemented in subclasses) """
        pass

    def shutdown(self):
        """ Action to perform when closing the logger """
        pass

    @staticmethod
    def time():
        """ Get a nicely formatted time string """
        return time.strftime("%a %d %Y %H:%M:%S", time.localtime())

    def format(self, string, level):
        """ Format the error message in a standard way """
        display_level = self.TYPES[level]
        return "- [%s] {%s} %s" % (display_level, self.time(), string)


class WindowLogger(Logger):

    """ Log messages to a window.

    The window object is passed in on construction, but
    only created if a message is written.
    """

    def __init__(self, debug_level, window):
        self.window = window
        super(WindowLogger, self).__init__(debug_level)

    def shutdown(self):
        if self.window is not None:
            self.window.is_open = False

    def _actual_log(self, string, level):
        if not self.window.is_open:
            self.window.create("rightbelow 6new")
        self.window.write(self.format(string, level)+"\n")


class FileLogger(Logger):

    """ Log messages to a window.

    The window object is passed in on construction, but
    only created if a message is written.
    """

    def __init__(self, debug_level, filename):
        self.filename = os.path.expanduser(filename)
        self.f = None
        super(FileLogger, self).__init__(debug_level)

    def __open(self):
        try:
            self.f = open(self.filename, 'w')
        except IOError as e:
            raise error.LogError("Invalid file name '%s' for log file: %s"
                                 % (self.filename, e))
        except:
            raise error.LogError("Error using file '%s' as a log file: %s"
                                 % (self.filename, sys.exc_info()[0]))

    def shutdown(self):
        if self.f is not None:
            self.f.close()

    def _actual_log(self, string, level):
        if self.f is None:
            self.__open()
        self.f.write(self.format(string, level)+"\n")
        self.f.flush()


class Log:

    loggers = {}

    def __init__(self, string, level=Logger.INFO):
        Log.log(string, level)

    @classmethod
    def log(cls, string, level=Logger.INFO):
        for logger in cls.loggers.values():
            logger.log(string, level)

    @classmethod
    def set_logger(cls, logger):
        k = logger.__class__.__name__
        if k in cls.loggers:
            cls.loggers[k].shutdown()
        cls.loggers[k] = logger

    @classmethod
    def remove_logger(cls, type):
        if type in cls.loggers:
            cls.loggers[type].shutdown()
            return True
        print("Failed to find logger %s in list of loggers" % type)
        return False

    @classmethod
    def shutdown(cls):
        for logger in cls.loggers.values():
            logger.shutdown()
        cls.loggers = {}
