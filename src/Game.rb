require_relative "./GameState"
require_relative "./Prefabs/Creatures/Players/index"
require_relative "./Prefabs/Creatures/Enemies/index"
require_relative "./Prefabs/Menu/ChoosePlayerMenu"
require_relative "./Prefabs/Menu/PlayMenu"
require_relative "./Prefabs/Menu/MainMenu"
require_relative "./Prefabs/Menu/YouDeadMenu"
require_relative "./Prefabs/Menu/ChooseSkillMenu"
require "colorize"

class Game
    attr_reader :player_list, :enemies_list, :current_menu

    def initialize
        @game_state = GameState.new()
        @current_menu = MainMenu.new(self)
        @player_list = PlayersList.get_player_list
        @enemies_list = EnemiesList.get_enemies_list
    end

    def initiate_skill(skill_idx)
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.player.use_skill(skill_idx, @game_state.enemy)

            self.trigger_enemy_attack
        end

        self.back_to_play_menu
    end

    def trigger_player_basic_attack
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.player.use_basic_attack(@game_state.enemy)

            self.trigger_enemy_attack
        end
    end

    def trigger_enemy_attack
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.enemy.use_basic_attack(@game_state.player)  
        end
    end

    
    def play_game(player)
        @game_state.set_player(player.new())

        @game_state.player.add_on_get_hit_listener(lambda{|damage| @game_state.logs.add_log("you received #{damage.to_s.colorize(:light_red)} damage")})
        @game_state.player.add_on_use_skill_listener(lambda{|skill, enemy| @game_state.logs.add_log("You used #{skill.name_colorized} on #{enemy.name_colorized}")})
        @game_state.player.add_on_dead_listener(lambda do 
            @game_state.logs.add_log("You have been slain!")
            @current_menu = YouDeadMenu.new(self)
        end)
        
        self.register_new_enemy

        @current_menu = PlayMenu.new(self)
    end

    def request_choose_player
        @current_menu = ChoosePlayerMenu.new(self)

        self
    end

    def quit_game
        @game_state.flag_exit = true

        self
    end

    def register_new_enemy
        @game_state.set_enemy(@enemies_list.sample.new())
        @game_state.enemy.add_on_get_hit_listener(lambda{|damage| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} received #{damage.to_s.colorize(:light_red)} damage")})
        @game_state.enemy.add_on_use_skill_listener(lambda{|skill, player| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} used #{skill.name_colorized} on you")})
        @game_state.enemy.add_on_dead_listener(lambda do 
                @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is down!")
                self.register_new_enemy
            end
        )
    end

    # setters
    def reset_game
        @game_state.reset_state

        self
    end
    
    def back_to_main_menu
        self.reset_game
        @current_menu = MainMenu.new(self)

        self
    end

    def back_to_play_menu
        @current_menu = PlayMenu.new(self)
        
        self
    end

    def go_to_choose_skill_menu
        @current_menu = ChooseSkillMenu.new(self)  

        self
    end

    def player
        @game_state.player
    end

    def enemy
        @game_state.enemy
    end

    def flag_exit
        @game_state.flag_exit
    end

    def logs
        @game_state.logs.logs
    end
end