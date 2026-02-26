require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class MainMenu < Menu
    def initialize(game)
        if game.is_a? Game
            super()
            @menu_list.push(MenuElement.new(
                menu_name: "Play Game", 
                on_selected: lambda {game.request_choose_player}
            ))
            
            @menu_list.push(MenuElement.new(
                menu_name: "Settings", 
                on_selected: lambda {game.go_to_settings_menu}
            ))

            @menu_list.push(MenuElement.new(
                menu_name: "Quit", 
                on_selected: lambda {game.quit_game}
            ))
        end
    end
end