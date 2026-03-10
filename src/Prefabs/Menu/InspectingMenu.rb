require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class InspectingMenu < Menu
    # @param game [Game]
    def initialize(game)
        throw "Error: game is not a Game object" unless game.is_a? Game
        @game = game
        @is_skill = true
        super()
    end

    def menu_list(selected_idx = 0)
        arr = [@game.enemy, @game.player].map.with_index do |creature, idx|
            MenuElement.new(
                menu_name: "#{selected_idx == idx ? "#{creature.name_colorized} <#{@is_skill ? "Skills" : "Buffs/Debuffs"}>" : creature.name_colorized}", 
                on_hover: lambda{selected_idx == idx ? @game.inspect_enemy : @game.inspect_player},
                on_select_left: lambda{@is_skill = !@is_skill},
                on_select_right: lambda{@is_skill = !@is_skill},
                tooltip: "Press enter to check #{creature.name_colorized}'s #{@is_skill ? "skills" : "buffs/debuffs"}",
                on_selected: lambda{@is_skill ? @game.go_to_skill_inspecting_menu : @game.go_to_effect_inspecting_menu}
            )
        end

        arr.push( MenuElement.new(
            menu_name: "Back", 
            on_selected: lambda{@game.back_to_play_menu}, 
            on_hover: lambda{@game.clear_inspecting}
        ))

        return arr
    end
end