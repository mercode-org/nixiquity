#!/usr/bin/env python3

from gi.repository import Gtk


class Installer:
    def __init__(self):
        self.builder = Gtk.Builder()
        self.builder.add_from_file('./ubiquity.ui')
