#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path("src", __dir__))
$LOAD_PATH.unshift(File.expand_path("src/Prefabs", __dir__))

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
    flag_exit = false

    user_input.register_up_listener(lambda {game.current_menu.focus_prev_element})
    user_input.register_down_listener(lambda {game.current_menu.focus_next_element})
    user_input.register_enter_listener(lambda {game.current_menu.select_current_element})
    game.add_on_quit_game_listener(lambda {flag_exit = true})

    until flag_exit == true
        system("clear") || system("cls")

        user_interface.print()
        user_input.get_arrow_input()
    end 
end