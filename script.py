#!/usr/bin/env python3

import subprocess
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('AppIndicator3', '0.1')
from gi.repository import Gtk, AppIndicator3, GObject



class DNSIndicator:
    def __init__(self):
        self.indicator = AppIndicator3.Indicator.new(
            "dns-switcher-indicator",
            "network-wireless",
            AppIndicator3.IndicatorCategory.APPLICATION_STATUS
        )
        self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
        self.indicator.set_menu(self.create_menu())

    def create_menu(self):
        menu = Gtk.Menu()

        options = [
            ("Auto", "auto"),
            ("403", "403"),
            ("Shecan", "shecan"),
            ("Quit", "quit"),
        ]

        for label, option in options:
            menu_item = Gtk.MenuItem(label)
            menu_item.connect("activate", self.menu_item_clicked, option)
            menu.append(menu_item)

        menu.show_all()
        return menu

    def menu_item_clicked(self, widget, option):
        if option == "quit":
            Gtk.main_quit()
        else:
            self.run_script(option)

    def run_script(self, option):
        script_path = "/opt/dns_switcher/setDNS.sh"
        subprocess.run([script_path, option])

def main():
    indicator = DNSIndicator()
    GObject.threads_init()
    Gtk.main()

if __name__ == "__main__":
    main()
