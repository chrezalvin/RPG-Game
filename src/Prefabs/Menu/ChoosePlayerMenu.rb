require_relative "../../Parents/Menu"
require_relative "../../Parents/MenuElement"
require_relative "../../Parents/Creature"
require_relative "../../Game"
require_relative "./playMenu"
require_relative "../Creatures/Players/index"

class ChoosePlayerMenu < Menu
    def initialize(game)
        super()
        @menu_list = PlayersList.get_player_list.map{
            |player| MenuElement.new(player.name, lambda{game.play_game(player)}, player.description == nil ? nil : player.description)
        }.push(MenuElement.new("Back to Main Menu", lambda{game.back_to_main_menu}))
    end
end