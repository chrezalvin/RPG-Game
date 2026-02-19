require_relative "../../Parents/Menu"
require_relative "../../Parents/MenuElement"
require_relative "../../Game"

class YouDeadMenu < Menu
    def initialize(game)
        super()

        if game.is_a? Game
            @menu_list = [
                MenuElement.new("Start a New Game", lambda{game.reset_game.request_choose_player}),
                MenuElement.new("Back to Main Menu", lambda{game.back_to_main_menu})
            ]
        end
    end
end