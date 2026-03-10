require "colorize"
require "Game"

require "Parents/Menu"
require "Parents/MenuElement"

class InspectEffectMenu < Menu
  # @param game [Game]
  def initialize(game)
    throw "Error: game is not a Game object" unless game.is_a? Game
    throw "Error: game.inspecting is nil" if game.inspecting == nil

    super()
    @menu_banner = "Inspecting #{game.inspecting.name_colorized}'s Buffs/Debuffs"
    @menu_list = game
      .inspecting
      .effects
      .each_with_index
      .map{
        |effect, idx|
            # @type [Effect]
            my_effect = effect
            MenuElement.new(
                menu_name: "#{my_effect.name} (#{my_effect.stack})",
                tooltip: my_effect.description
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