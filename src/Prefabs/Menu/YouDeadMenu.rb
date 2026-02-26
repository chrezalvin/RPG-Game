require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class YouDeadMenu < Menu
    def initialize(game)
        throw "Error: game is not a Game object" unless game.is_a? Game
        super()

        @menu_list = []

        @menu_list.push(MenuElement.new(
            menu_name: "Start a New Game", 
            on_selected: lambda{game.request_choose_player}
        ))

        @menu_list.push(MenuElement.new(
            menu_name: "Back to Main Menu", 
            on_selected: lambda{game.back_to_main_menu}
        ))
    end
end