#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path("src", __dir__))
$LOAD_PATH.unshift(File.expand_path("src/Prefabs", __dir__))

require "json"
require "colorize"

require_relative "src/Game"
require_relative "src/UserInterface"
require_relative "src/UserInput"

require_relative "src/Data/ConfigData"

if __FILE__ == $0
    configData = ConfigData.new("config.json")

    game = Game.new(configData)
    user_interface = UserInterface.new(game)
    user_input = UserInput.new()
    flag_exit = false

    user_input.on_up{game.menu_manager.focus_prev_element}
    user_input.on_down{game.menu_manager.focus_next_element}
    user_input.on_enter{game.menu_manager.select_current_element}
    user_input.on_right{game.menu_manager.select_right_current_element}
    user_input.on_left{game.menu_manager.select_left_current_element}

    game.on_quit_game{flag_exit = true}

    until flag_exit == true
        system("clear") || system("cls")

        user_interface.print()
        user_input.get_arrow_input()
    end 
end