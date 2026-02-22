#!/usr/bin/env ruby

require_relative "src/Game"
require_relative "src/UserInterface"
require_relative "src/UserInput"
require_relative "src/Prefabs/Menu/MainMenu"
require_relative "src/Prefabs/Creatures/Enemies/Minotaur"
require "colorize"

if __FILE__ == $0
    iii = 0
    game = Game.new()
    user_interface = UserInterface.new(game)
    user_input = UserInput.new()

    user_input.register_up_listener(lambda {game.current_menu.focus_prev_element if game.current_menu.is_a? Menu})
    user_input.register_down_listener(lambda {game.current_menu.focus_next_element if game.current_menu.is_a? Menu})
    user_input.register_enter_listener(lambda {game.current_menu.select_current_element if game.current_menu.is_a? Menu})

    until game.flag_exit == true
        system("clear") || system("cls")

        user_interface.print()
        user_input.get_arrow_input()
        iii += 1

        if iii > 10000
            game.quit_game()
        end
    end 
end