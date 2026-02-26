#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path("src", __dir__))
$LOAD_PATH.unshift(File.expand_path("src/Prefabs", __dir__))

require "json"
require "colorize"

require_relative "src/Game"
require_relative "src/UserInterface"
require_relative "src/UserInput"
require_relative "src/Prefabs/Menu/MainMenu"
require_relative "src/Prefabs/Creatures/Enemies/Minotaur"

if __FILE__ == $0
    config = JSON.parse(File.read("config.json"))

    if config["user_data_folder"] == nil || config["audio_folder"] == nil
        puts "Error: Invalid config file. Please make sure the config file contains 'user_data_folder' and 'audio_folder' keys.".red
        exit(1)
    end

    user_data_file = config["user_data_folder"]
    audio_folder = config["audio_folder"]

    select_sound_file = "select.mp3"

    game = Game.new()
    user_interface = UserInterface.new(game)
    user_input = UserInput.new()
    flag_exit = false

    user_input.on_up{game.current_menu.focus_prev_element}
    user_input.on_down{game.current_menu.focus_next_element}
    user_input.on_enter{game.current_menu.select_current_element}
    user_input.on_right{game.current_menu.select_right_current_element}
    user_input.on_left{game.current_menu.select_left_current_element}

    game.on_quit_game{flag_exit = true}

    until flag_exit == true
        system("clear") || system("cls")

        user_interface.print()
        user_input.get_arrow_input()
    end 
end