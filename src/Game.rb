require "colorize"
require "forwardable"
require "GameState"
require "Sound"

require "utils/Event"

require "Creatures/Players/index"
require "Creatures/Enemies/index"

require "Menu/ChoosePlayerMenu"
require "Menu/PlayMenu"
require "Menu/MainMenu"
require "Menu/YouDeadMenu"
require "Menu/ChooseSkillMenu"
require "Menu/InspectingMenu"
require "Menu/UserSettingsMenu"

class Game
    extend Forwardable

    attr_reader :player_list, :enemies_list, :current_menu, :inspecting, :enemy_about_to_use,
        :player, :enemy, :volume, :is_use_audio

    def_delegators :@game_state, :player, :enemy, :volume, :is_use_audio

    def initialize(user_data_folder = "data/", audio_folder = "assets/sounds/")
        @game_state = GameState.new(user_data_folder)
        @current_menu = MainMenu.new(self)
        @player_list = PlayersList.get_player_list
        @enemies_list = EnemiesList.get_enemies_list
        @sound = Sound.new(audio_folder)
        @inspecting = nil
        @enemy_about_to_use = nil

        @on_quit_game_listeners = Event.new()
    end

    def initiate_skill(skill_idx)
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.player.use_skill(skill_idx, @game_state.enemy)

            if @game_state.enemy.is_dead?
                self.register_new_enemy
            else
                self.trigger_enemy_attack
                self.decide_next_enemy_action
            end

        end
    end

    def trigger_player_basic_attack
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.player.use_basic_attack(@game_state.enemy)

            if @game_state.enemy.is_dead?
                self.register_new_enemy
            else
                self.trigger_enemy_attack
                self.decide_next_enemy_action
            end

        end
    end

    def trigger_enemy_attack
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.enemy.use_skill_by_instance(@enemy_about_to_use, @game_state.player)
        end
    end

    
    def play_game(player)
        @game_state.set_player(player.new())

        @game_state.player.add_on_get_hit_listener(lambda{|damage| @game_state.logs.add_log("you received #{damage.amount_colorized} #{damage.damage_type} damage")})
        @game_state.player.add_on_use_skill_listener(lambda{|skill, enemy| @game_state.logs.add_log("You used #{skill.name_colorized} on #{enemy.name_colorized}")})
        @game_state.player.add_on_effect_applied_listener(lambda{|effect| @game_state.logs.add_log("You are affected by #{effect.name_colorized}")})
        @game_state.player.add_on_effect_expired_listener(lambda{|effect| @game_state.logs.add_log("#{effect.name_colorized} on you has expired")})
        @game_state.player.add_on_heal_listener(lambda{|heal_instance| @game_state.logs.add_log("You healed #{heal_instance.amount_colorized} HP")})
        @game_state.player.add_on_dead_listener(lambda do 
            @game_state.logs.add_log("You have been slain!")
            @current_menu = YouDeadMenu.new(self)
        end)

        @game_state.player.add_on_use_skill_listener(lambda{|skill, _| skill.sound_file != nil ? self.play_audio(skill.sound_file) : nil})
        
        self.register_new_enemy

        @current_menu = PlayMenu.new(self)
    end

    def decide_next_enemy_action
        if @game_state.enemy != nil && @game_state.player != nil
            @enemy_about_to_use = @game_state.enemy.decide_next_action(@game_state.player)

            @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is preparing to use #{@enemy_about_to_use.name_colorized}!")
        end
    end

    def request_choose_player
        @game_state.reset_state
        @current_menu = ChoosePlayerMenu.new(self)

        self
    end

    def register_new_enemy
        @game_state.set_enemy(@enemies_list.sample.new())
        @game_state.enemy.add_on_get_hit_listener(lambda{|damage| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} received #{damage.amount_colorized} #{damage.damage_type} damage")})
        @game_state.enemy.add_on_use_skill_listener(lambda{|skill, player| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} used #{skill.name_colorized}")})
        @game_state.enemy.add_on_effect_applied_listener(lambda{|effect| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is affected by #{effect.name_colorized}")})
        @game_state.enemy.add_on_effect_expired_listener(lambda{|effect| @game_state.logs.add_log("#{effect.name_colorized} on #{@game_state.enemy.name_colorized} has expired")})
        @game_state.enemy.add_on_heal_listener(lambda{|heal_instance| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} healed #{heal_instance.amount_colorized} HP")})
        @game_state.enemy.add_on_dead_listener(lambda do 
                @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is down!")
            end
        )

        @game_state.enemy.add_on_use_skill_listener(lambda{|skill, _| skill.sound_file != nil ? self.play_audio(skill.sound_file) : nil})

        self.decide_next_enemy_action
    end

    def play_audio(filename)
        if @game_state.is_use_audio
            @sound.play_sound(filename, @game_state.volume)
        end
    end

    def set_use_audio(is_use_audio)
        @game_state.set_use_audio(is_use_audio)
    end

    def set_audio(volume)
        @game_state.set_audio(volume)
    end
    
    def back_to_main_menu
        @game_state.reset_state
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

    def go_to_inspecting_menu
        @current_menu = InspectingMenu.new(self)

        self
    end

    def go_to_settings_menu
        @current_menu = UserSettingsMenu.new(self)

        self
    end

    def inspect_player
        @inspecting = @game_state.player
    end

    def inspect_enemy
        @inspecting = @game_state.enemy
    end

    def clear_inspecting
        @inspecting = nil
    end

    def logs
        @game_state.logs.logs
    end

    def quit_game
        @on_quit_game_listeners.emit()

        self
    end

    def add_on_quit_game_listener(listener)
        @on_quit_game_listeners.subscribe(listener)
    end
end