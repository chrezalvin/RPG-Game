require_relative "../../Game"
require_relative "./MainMenu"
require_relative "./Menu"
require_relative "./MenuElement"

class PlayMenu < Menu
    def initialize(game)
        super()
        if game.is_a? Game
            @menu_list = [
                MenuElement.new("Basic Attack", lambda{game.trigger_player_basic_attack}),
                MenuElement.new("Skills", lambda{}, "Select a skill"),
                MenuElement.new("Back to Main Menu", lambda{game.back_to_main_menu})
            ]
        end
    end
end