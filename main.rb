#!/usr/bin/env ruby

require "curses"
require "io/console"

def user_interface(options, selected)
    for option_idx in 0..(options.length - 1)
        if selected == option_idx
            puts("> #{options[option_idx]}")
        else
            puts("  #{options[option_idx]}")
        end
    end

    puts("\nPress up and down key to select and Enter to confirm")
end

if __FILE__ == $0
    print "\e[8;40;80t" # resizes terminal window to 40x80 characters

    iii = 0
    select_idx = 0
    options = ["test 1", "test 2", "test 3"]

    while iii < 10 do
        system("clear") || system("cls")

        user_interface(options, select_idx)
        user_input = STDIN.getch

        if user_input.bytes == [224, 80]
            select_idx = (select_idx + 1) % 3
        elsif user_input.bytes == [224, 72]
            select_idx = (select_idx - 1) % 3
        end

        iii += 1
    end
end