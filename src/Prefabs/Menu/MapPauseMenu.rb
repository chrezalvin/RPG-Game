require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class MapPauseMenu < Menu
    # @param game [Game] the game instance that this menu is in
    def initialize(game)
        throw "MapMenu must be initialized with a Game instance" unless game.is_a? Game
        super()

        @game = game
    end

    def menu_list(selected_idx = 0)
        [
            MenuElement.new(
                menu_name: "Resume",
                on_selected: lambda {@game.go_to_map_menu}
            ),
            MenuElement.new(
                menu_name: "Quit to Main Menu",
                on_selected: lambda {@game.back_to_main_menu}
            )
        ]
    end

    def on_escape
        @game.go_to_map_menu
    end
end