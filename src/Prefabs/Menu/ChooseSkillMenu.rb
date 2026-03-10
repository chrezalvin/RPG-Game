require "colorize"
require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class ChooseSkillMenu < Menu
  # @param game [Game]
  def initialize(game)
    throw "Error: game is not a Game object" unless game.is_a? Game
    throw "Error: game.player is nil" if game.player == nil

    super()

    @menu_list = game
      .player
      .usable_skills
      .each_with_index
      .map{
        |skill, idx| 
          if skill.can_use_skill?(game.enemy)
            skill_mp_usage = skill.class.respond_to?(:skill_mp_usage) ? skill.class.skill_mp_usage : nil
            MenuElement.new(
              menu_name: "#{skill.name} #{skill_mp_usage != nil ? "(#{skill_mp_usage} MP)".colorize(:light_blue) : ""}", 
              on_selected: lambda{game.initiate_skill(idx)},
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

  def menu_list(selected_idx = 0)
    @menu_list
  end
end