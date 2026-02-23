require "colorize"

require "Parents/Menu"
require "Parents/MenuElement"

class ChooseSkillMenu < Menu
  def initialize(game)
      super()

      if (game.is_a? Game) && (game.player != nil)
        @menu_list = game
          .player
          .usable_skills
          .each_with_index
          .map{            
            |skill, idx| 
              MenuElement.new(
                menu_name: skill.name, 
                on_selected: lambda{game.initiate_skill(idx); game.back_to_play_menu},
                tooltip: skill.description
              )
              if skill.can_use_skill?(game.enemy)
                MenuElement.new(
                  menu_name: skill.name, 
                  on_selected: lambda{game.initiate_skill(idx); game.back_to_play_menu},
                  tooltip: skill.description
                )
              else
                MenuElement.new(
                  menu_name: "#{skill.name.to_s.colorize(:grey)}", 
                  tooltip: skill.description
                )
              end
            }
          .push(MenuElement.new(
            menu_name: "Back", 
            on_selected: lambda{game.back_to_play_menu}
          ))
      end
  end
end