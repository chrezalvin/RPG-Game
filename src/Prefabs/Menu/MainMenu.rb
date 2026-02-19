require_relative "../../Game"
require_relative "../../Parents/Menu"
require_relative "../../Parents/MenuElement"

class MainMenu < Menu
    def initialize(game)
        if game.is_a? Game
            super()
            @menu_list.push(MenuElement.new("Play Game", lambda {game.request_choose_player}))
            @menu_list.push(MenuElement.new("Quit", lambda {game.quit_game}))
        end
    end
end