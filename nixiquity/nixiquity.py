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
        self.builder.connect_signals(self)

        self.window = self.builder.get_object("live_installer")
        self.window.show()
        self.quit_warning = self.builder.get_object("warning_dialog")

    def on_quit_clicked(self, event):
        self.quit_warning.show()

    def on_quit_cancelled(self, event):
        self.quit_warning.hide()

    def quit_installer(self, event=None):
        Gtk.main_quit()

    def loop(self):
        """Run the UI's main loop until it returns control to us."""
        # self.allow_change_step(True)
        # self.set_focus()
        Gtk.main()
        # self.pending_quits = max(0, self.pending_quits - 1)

def main():
    installer = Installer()
    installer.loop()
