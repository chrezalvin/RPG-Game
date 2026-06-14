require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class MapMenu < Menu
    # @param game [Game] the game instance that this menu is in
    def initialize(game)
        throw "MapMenu must be initialized with a Game instance" unless game.is_a? Game
        super()

        @game = game
    end

    def menu_list(selected_idx = 0)
        player_instance = @game.player_map_instance
        pov = @game.map.get_pov(player_instance)

        pov.map do |map_instances|
            MenuElement.new(
                menu_name: map_instances.map{|instance| instance.symbol}.join(" "),
                on_select_left: lambda {@game.map.move_instance(player_instance, "left")},
                on_select_right: lambda {@game.map.move_instance(player_instance, "right")},
                on_select_next: lambda {@game.map.move_instance(player_instance, "down")},
                on_select_prev: lambda {@game.map.move_instance(player_instance, "up")},
                tooltip: "Use arrow keys to move in the corresponding direction, press ESC to open the pause menu"
            )
        end
    end

    def on_escape
        @game.go_to_map_pause_menu
    end
end