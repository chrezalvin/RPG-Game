require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class UserSettingsMenu < Menu
    # Initialize the user settings menu with the current game settings
    # @param game [Game] The game object containing the current settings
    def initialize(game)
        if game.is_a? Game
            super()
            reload_menu(game)
        end
    end

    # Reload the menu list based on the current game settings
    # @param game [Game] The game object containing the current settings
    def reload_menu(game)
        @menu_list = []
        @menu_list.push(MenuElement.new(
            menu_name: "Use Volume       < #{game.is_use_audio ? "On" : "Off"} >",
            on_select_right: lambda {game.set_use_audio(!game.is_use_audio); reload_menu(game);},
            on_select_left: lambda {game.set_use_audio(!game.is_use_audio); reload_menu(game);},
            tooltip: "Press Left or Right arrow key to toggle"
        ))
        @menu_list.push(MenuElement.new(
            menu_name: "Volume           < #{game.volume}% >" ,
            on_select_right: lambda {game.set_audio([game.volume + 10, 100].min); reload_menu(game);},
            on_select_left: lambda {game.set_audio([game.volume - 10, 0].max); reload_menu(game);},
            tooltip: "Press Left or Right arrow key to adjust volume"
        ))
        @menu_list.push(MenuElement.new(menu_name: "Back", on_selected: lambda {game.back_to_main_menu}))
    end
end