# -*- coding: utf-8 -*-

import mock
import completor
from completor.compat import to_unicode

from completers.common import Common  # noqa


def test_on_data(vim_mod, create_buffer):
    common = completor.get('common')
    common.input_data = 'urt'

    vim_mod.current.buffer.number = 1
    vim_mod.current.window.cursor = (1, 2)

    buffer = create_buffer(1)
    with open(__file__) as f:
        buffer[:] = f.read().split('\n')

    vim_mod.buffers = [buffer]
    assert common.on_data(b'complete', b'urt') == [
        {'menu': '[snip] mock snips', 'word': 'urt', 'dup': 1},
        {'menu': '[ID]', 'word': 'current'}
    ]

    vim_mod.vars = {'completor_disable_ultisnips': 1}

    assert common.on_data(b'complete', b'urt') == [
        {'menu': '[ID]', 'word': 'current'}]

    vim_mod.vars = {
        'completor_disable_buffer': 1,
        'completor_disable_ultisnips': 0
    }

    assert common.on_data(b'complete', b'urt') == [
        {'menu': '[snip] mock snips', 'word': 'urt', 'dup': 1}]


def test_unicode(vim_mod, create_buffer):
    buffer = create_buffer(1)
    with open('./tests/test.txt') as f:
        buffer[:] = f.read().split('\n')
    vim_mod.buffers = [buffer]
    vim_mod.current.buffer.number = 1
    vim_mod.current.window.cursor = (1, 16)

    buf = completor.get('buffer')
    buf.input_data = to_unicode('pielę pielęgn', 'utf-8')
    assert buf.start_column() == 7
    assert buf.on_data(b'complete', b'piel\xc4\x99gn') == [
        {'menu': '[ID]', 'word': to_unicode('pielęgniarką', 'utf-8')},
        {'menu': '[ID]', 'word': to_unicode('pielęgniarkach', 'utf-8')}
    ]


def test_min_chars(vim_mod, monkeypatch):
    vim_mod.vars = {'completor_min_chars': 3}
    common = completor.get('common')
    mock_buffer_parse = mock.Mock(return_value=['hello'])
    monkeypatch.setattr(completor.get('buffer'), 'parse', mock_buffer_parse)

    mock_snips_parse = mock.Mock(return_value=['snips'])
    monkeypatch.setattr(completor.get('ultisnips'), 'parse', mock_snips_parse)

    assert common.on_data(b'complete', b'he') == []
    mock_buffer_parse.assert_not_called()
    mock_snips_parse.assert_not_called()

    assert common.on_data(b'complete', b'hello') == ['snips', 'hello']
    mock_buffer_parse.assert_called_with('hello')
    mock_snips_parse.assert_called_with('hello')
