require_relative "./Menu"
require_relative "./MenuElement"

class ChooseSkillMenu < Menu
  def initialize(game)
      super()

      if (game.is_a? Game) && (game.player != nil)
        @menu_list = game
          .player
          .usable_skills
          .each_with_index
          .map{
            |skill, idx| MenuElement.new(skill.name, lambda{game.initiate_skill(idx)}, skill.description)
          }
          .push(MenuElement.new("Back", lambda{game.back_to_play_menu}))
      end
  end
end