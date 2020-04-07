#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')

from gi.repository import Gtk
from os import path

LIBDIR = path.dirname(__file__)
UIDIR = LIBDIR + '/glade'

class Installer:
    def __init__(self):
        self.builder = Gtk.Builder()
        self.builder.add_from_file('%s/ubiquity.ui' % UIDIR)

    def loop(self):
        """Run the UI's main loop until it returns control to us."""
        # self.allow_change_step(True)
        # self.set_focus()
        Gtk.main()
        # self.pending_quits = max(0, self.pending_quits - 1)

def main():
    installer = Installer()
    installer.loop()
