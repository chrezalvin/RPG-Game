require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class ChoosePlayerMenu < Menu
    def initialize(game)
        throw "Error: game is not a Game object" unless game.is_a? Game
        super()


        @menu_list = game.player_list.map{
            |player| MenuElement.new(
                menu_name: player.name, 
                on_selected: lambda{game.play_game(player)}, 
                tooltip: player.description == nil ? nil : player.description
            )
        }.push(MenuElement.new(
            menu_name: "Back to Main Menu", 
            on_selected: lambda{game.back_to_main_menu}
        ))
    end
end