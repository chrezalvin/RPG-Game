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

    # @type [Creature]
    inspecting = game.inspecting

    @menu_list = inspecting
      .skills
      .skills
      .each_with_index
      .map{
        |skill, idx| 
          MenuElement.new(
            menu_name: "#{skill.name}",
            tooltip: skill.description
          )
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