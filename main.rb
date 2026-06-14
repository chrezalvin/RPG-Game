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

    user_input.on_up{game.input_up}
    user_input.on_down{game.input_down}

    user_input.on_enter{game.input_enter}
    user_input.on_space{game.input_enter}

    user_input.on_right{game.input_right}
    user_input.on_left{game.input_left}

    user_input.on_esc{game.input_escape}

    game.on_quit_game{flag_exit = true}

    until flag_exit == true
        system("clear") || system("cls")

        user_interface.print()
        user_input.get_arrow_input()
    end 
end