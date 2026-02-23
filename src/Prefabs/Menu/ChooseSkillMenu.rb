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
              if skill.can_use_skill?(game.enemy)
                MenuElement.new(skill.name, lambda{game.initiate_skill(idx); game.back_to_play_menu}, skill.description)
              else
                MenuElement.new("#{skill.name.to_s.colorize(:grey)}", lambda{}, skill.description)
              end
            }
          .push(MenuElement.new("Back", lambda{game.back_to_play_menu}))
      end
  end
end