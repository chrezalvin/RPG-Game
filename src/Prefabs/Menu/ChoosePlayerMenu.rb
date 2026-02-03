require_relative "./Menu"
require_relative "./MenuElement"
require_relative "./playMenu"
require_relative "../../Game"
require_relative "../Creatures/Players/index"
require_relative "../Creatures/Creature"

class ChoosePlayerMenu < Menu
    def initialize(game)
        super()
        @menu_list = PlayersList.get_player_list.map{
            |player| MenuElement.new(player.name, lambda{game.play_game(player)})
        }.push(MenuElement.new("Back to Main Menu", lambda{game.back_to_main_menu}))
    end
end