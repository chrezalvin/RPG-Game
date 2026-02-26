require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class PlayMenu < Menu
    def initialize(game)
        throw "Error: game is not a Game object" unless game.is_a? Game
        super()

        unless game.player.basic_attack == nil
            @menu_list.push(MenuElement.new(
                menu_name: "#{game.player.basic_attack.name}", 
                on_selected: lambda{game.trigger_player_basic_attack}
            ))
        end
        unless game.player.usable_skills.empty?
            @menu_list.push(MenuElement.new(
                menu_name: "Skills", 
                on_selected: lambda{game.go_to_choose_skill_menu}, 
                tooltip: "Select a skill"
            ))
        end

        @menu_list.push(MenuElement.new(
            menu_name: "Inspect", 
            on_selected: lambda{game.go_to_inspecting_menu}, 
            on_hover: "Check status of you and your enemy"
        ))
        @menu_list.push(MenuElement.new(menu_name: "Do nothing"))
        @menu_list.push(MenuElement.new(
            menu_name: "Back to Main Menu", 
            on_selected: lambda{game.back_to_main_menu}
        ))
    end
end