# ============================================================================
# FILE: command.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
#         Luis Carlos Cruz Carballo <lcruzc at linkux-it.com>
# License: MIT license
# ============================================================================

import re

from .base import Base
from denite.util import globruntime
from re import sub


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'command'
        self.kind = 'command'
        self.commands = []

        self._re_command = re.compile(r'^\|:.+\|')
        self._re_tokens = re.compile(
            r'^\|:(.+)\|[\t\s]+:([^\t]+)[\t\s]+(.+)')

    def on_init(self, context):
        runtimepath = self.vim.eval('&runtimepath')
        self._helpfiles = globruntime(runtimepath, 'doc/index.txt')

    def gather_candidates(self, context):
        context['is_interactive'] = True

        has_cmdline = self.vim.call('denite#helper#has_cmdline')
        template = "echo execute(input(':', '{0}', 'command'))"
        if ' ' not in context['input'] or not has_cmdline:
            if not self.commands:
                self._cache_helpfile()
            return self.commands + [{
                'action__command': template.format(x),
                'word': x,
            } for x in self.vim.call('getcompletion', '', 'command')]

        prefix = sub('\w*$', '', context['input'])

        candidates = [{
            'action__command': template.format(prefix + x),
            'word': prefix + x,
        } for x in self.vim.call(
            'getcompletion', context['input'], 'cmdline')]
        if not candidates:
            candidates = [{
                'action__command': template.format(context['input']),
                'word': context['input'],
            }]
        return candidates

    def _cache_helpfile(self):
        for helpfile in self._helpfiles:
            with open(helpfile) as doc:
                for line in [x for x in doc.readlines()
                             if self._re_command.match(x)]:
                    tokens = self._re_tokens.match(line).groups()
                    command = "execute input(':{0} ')".format(tokens[0])
                    self.commands.append({
                        'action__command': command,
                        'word': '{0:<20} -- {1}'.format(
                            tokens[0], tokens[2],
                        ),
                    })
