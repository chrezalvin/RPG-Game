require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class DefeatEnemyMenu < Menu
    # @param game [Game] the game instance that this menu is in
    # @param enemy [Creature] the enemy that the player is about to fight
    def initialize(game, enemy)
        throw "Error: game is not a Game object" unless game.is_a? Game
        super()

        @menu_banner = "You have defeated the #{enemy.name_colorized}!"

        @menu_list.push(
            MenuElement.new(
                menu_name: "Back to Map",
                on_selected: lambda {game.go_to_map_menu},
            )
        )
    end

    def menu_list(selected_idx = 0)
        @menu_list
    end
end