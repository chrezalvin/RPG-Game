require "colorize"
require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class InspectSkillMenu < Menu
  # @param game [Game]
  def initialize(game)
    throw "Error: game is not a Game object" unless game.is_a? Game
    throw "Error: game.inspecting is nil" if game.inspecting == nil

    super()
    @menu_banner = "Inspecting #{game.inspecting.name_colorized}'s Skills"
    @menu_list = game
      .inspecting
      .usable_skills
      .each_with_index
      .map{
        |skill, idx| 
          skill_mp_usage = skill.class.respond_to?(:skill_mp_usage) ? skill.class.skill_mp_usage : nil
          if skill.can_use_skill?(game.enemy)
            MenuElement.new(
              menu_name: "#{skill.name} #{skill_mp_usage != nil ? "(#{skill_mp_usage} MP)".colorize(:light_blue) : ""}",
              tooltip: skill.description
            )
          else
            MenuElement.new(
              menu_name: "#{skill.name.to_s} #{skill_mp_usage != nil ? "(#{skill_mp_usage} MP)" : ""}".colorize(:grey), 
              tooltip: skill.description
            )
          end
        }
      .push(MenuElement.new(
        menu_name: "Back", 
        on_selected: lambda{game.clear_inspecting; game.back_to_play_menu}
      ))
  end

  def menu_list(selected_idx = 0)
    @menu_list
  end
end