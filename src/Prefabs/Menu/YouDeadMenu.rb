require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class YouDeadMenu < Menu
    def initialize(game)
        super()

        if game.is_a? Game
            @menu_list = [
                MenuElement.new(menu_name: "Start a New Game", on_selected: lambda{game.request_choose_player}),
                MenuElement.new(menu_name: "Back to Main Menu", on_selected: lambda{game.back_to_main_menu})
            ]
        end
    end
end