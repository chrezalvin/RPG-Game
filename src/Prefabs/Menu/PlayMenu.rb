require_relative "../../Game"
require_relative "./MainMenu"
require_relative "./Menu"
require_relative "./MenuElement"

class PlayMenu < Menu
    def initialize(game)
        super()
        if game.is_a? Game
            unless game.player.basic_attack == nil
                @menu_list.push(MenuElement.new("#{game.player.basic_attack.name}", lambda{game.trigger_player_basic_attack}))
            end
            unless game.player.usable_skills.empty?
                @menu_list.push(MenuElement.new("Skills", lambda{game.go_to_choose_skill_menu}, "Select a skill"))
            end

            @menu_list.push(MenuElement.new("Do nothing", lambda{}))
            @menu_list.push(MenuElement.new("Back to Main Menu", lambda{game.back_to_main_menu}))
        end
    end
end