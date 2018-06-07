from . import setup
import unittest
from vdebug.opts import Options,OptionsError

class OptionsTest(unittest.TestCase):

    def tearDown(self):
        Options.instance = None

    def test_has_instance(self):
        Options.set({1:"hello", 2:"world"})
        self.assertIsInstance(Options.inst(), Options)

    def test_get_option(self):
        Options.set({'foo':"hello",'bar':"world"})
        self.assertEqual("hello", Options.get('foo'))

    def test_get_option_for_print(self):
        Options.set({'foo':"", 'bar':"world"})
        self.assertEqual("<empty>", Options.get_for_print('foo'))
        self.assertEqual("world", Options.get_for_print('bar'))

    def test_get_option_as_type(self):
        Options.set({'foo':"1", 'bar':"2"})
        opt = Options.get('foo', int)
        self.assertIsInstance(opt, int)
        self.assertEqual(1, opt)

    def test_overwrite(self):
        Options.set({'foo':"hello", 'bar':"world"})
        Options.overwrite('foo', "hi")
        self.assertEqual("hi", Options.get('foo'))

    def test_option_is_not_set(self):
        Options.set({'foo':"", 'bar':"2"})
        self.assertFalse(Options.isset("monkey"))

    def test_option_is_not_valid(self):
        Options.set({'foo':"", 'bar':"2"})
        self.assertFalse(Options.isset("foo"))

    def test_option_isset(self):
        Options.set({'foo':"", 'bar':"2"})
        self.assertTrue(Options.isset("bar"))

    def test_uninit_raises_error(self):
        self.assertRaises(OptionsError, Options.isset,'something')

    def test_get_raises_error(self):
        Options.set({'foo':"1", 'bar':"2"})
        self.assertRaises(OptionsError, Options.get,'something')
