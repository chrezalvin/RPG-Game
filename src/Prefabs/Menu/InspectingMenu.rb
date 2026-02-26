require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class InspectingMenu < Menu
    def initialize(game)
        throw "Error: game is not a Game object" unless game.is_a? Game

        super()

        @menu_list = []
        
        @menu_list.push(MenuElement.new(
            menu_name: "#{game.enemy.name_colorized}", 
            on_hover: lambda{game.inspect_enemy}
        ))

        @menu_list.push(MenuElement.new(
            menu_name: "#{game.player.name_colorized}", 
            on_hover: lambda{game.inspect_player}
        ))

        @menu_list.push(MenuElement.new(
            menu_name: "Back", 
            on_selected: lambda{game.back_to_play_menu}, 
            on_hover: lambda{game.clear_inspecting}
        ))

        self.hover_current_element
    end
end