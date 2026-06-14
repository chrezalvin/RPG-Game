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

    @game = game
  end

  def menu_list(selected_idx = 0)
    # @type [Creature]
    player = @game.player
    player
      .skills.skills
      .each_with_index
      .map{
        |skill, idx|
          MenuElement.new(
            menu_name: "#{skill.name_display}",
            on_selected: skill.can_use_skill?(@game.enemy) ? lambda{player.skill_usable.use_skill(skill, @game.enemy)} : nil,
            tooltip: skill.description
          )
      }
      .push(MenuElement.new(
        menu_name: "Back",
        on_selected: lambda{@game.back_to_play_menu}
      ))
  end
end