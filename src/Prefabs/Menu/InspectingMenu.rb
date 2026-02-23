require "Parents/Menu"
require "Parents/MenuElement"

class InspectingMenu < Menu
    def initialize(game)
        super()

        @menu_list = []
        
        @menu_list.push(MenuElement.new("#{game.enemy.name_colorized}", lambda{}, nil, lambda{game.inspect_enemy}))
        @menu_list.push(MenuElement.new("#{game.player.name_colorized}", lambda{}, nil, lambda{game.inspect_player}))
        @menu_list.push(MenuElement.new("Back", lambda{game.back_to_play_menu}, nil, lambda{game.clear_inspecting}))

        self.hover_current_element
    end
end