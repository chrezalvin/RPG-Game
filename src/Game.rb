require "colorize"
require "forwardable"
require "GameState"

require "utils/SoundPlayer"
require "utils/Event"

require "Creatures/Players/index"
require "Creatures/Enemies/index"

require "Parents/MenuManager"
require "Menu/ChoosePlayerMenu"
require "Menu/PlayMenu"
require "Menu/MainMenu"
require "Menu/YouDeadMenu"
require "Menu/ChooseSkillMenu"
require "Menu/InspectingMenu"
require "Menu/UserSettingsMenu"

require "Sounds/SelectSound"

class Game
    extend Forwardable

    attr_reader :player_list, :enemies_list, :menu_manager, :inspecting, :enemy_about_to_use, :on_quit_game,
        :player, :enemy, :volume, :is_use_audio, :inspecting, :inspecting_player, :inspecting_enemy, :clear_inspecting

    def_delegators :@game_state, :player, :enemy, :volume, :is_use_audio, :inspecting, :inspect_player, :inspect_enemy, :clear_inspecting

    def_delegator :@on_quit_game_listeners, :subscribe, :on_quit_game

    def initialize(user_data_folder = "data/", audio_folder = "assets/sounds/")
        @game_state = GameState.new(user_data_folder)
        @menu_manager = MenuManager.new(MainMenu.new(self))
        @player_list = PlayersList.get_player_list
        @enemies_list = EnemiesList.get_enemies_list
        @sound = SoundPlayer.new(audio_folder, @game_state)
        @enemy_about_to_use = nil

        @menu_manager.on_focus_next_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_focus_prev_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_select_left_current_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_select_right_current_element{@sound.play_sound(SelectSound.new())}

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

        @game_state.player.on_take_damage{|damage| @game_state.logs.add_log("you received #{damage.amount_colorized} #{damage.damage_type} damage")}
        @game_state.player.on_use_skill{|skill, enemy| @game_state.logs.add_log("You used #{skill.name_colorized} on #{enemy.name_colorized}")}
        @game_state.player.on_effect_applied{|effect| @game_state.logs.add_log("You are affected by #{effect.name_colorized}")}
        @game_state.player.on_effect_expired{|effect| @game_state.logs.add_log("#{effect.name_colorized} on you has expired")}
        @game_state.player.on_heal(lambda{|heal_instance| @game_state.logs.add_log("You healed #{heal_instance.amount_colorized} HP")})
        @game_state.player.on_dead(lambda do 
            @game_state.logs.add_log("You have been slain!")
            @menu_manager.change_menu(YouDeadMenu.new(self))
        end)

        @game_state.player.on_use_skill{|skill, _| skill.sound != nil ? @sound.play_sound(skill.sound) : nil}
        
        self.register_new_enemy

        @menu_manager.change_menu(PlayMenu.new(self))
    end

    def decide_next_enemy_action
        if @game_state.enemy != nil && @game_state.player != nil
            @enemy_about_to_use = @game_state.enemy.decide_next_action(@game_state.player)

            @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is preparing to use #{@enemy_about_to_use.name_colorized}!")
        end
    end

    def register_new_enemy
        @game_state.set_enemy(@enemies_list.sample.new())

        @game_state.enemy.on_take_damage{|damage| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} received #{damage.amount_colorized} #{damage.damage_type} damage")}
        @game_state.enemy.on_use_skill{|skill, player| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} used #{skill.name_colorized}")}
        @game_state.enemy.on_effect_applied{|effect| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is affected by #{effect.name_colorized}")}
        @game_state.enemy.on_effect_expired{|effect| @game_state.logs.add_log("#{effect.name_colorized} on #{@game_state.enemy.name_colorized} has expired")}
        @game_state.enemy.on_heal{|heal_instance| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} healed #{heal_instance.amount_colorized} HP")}
        @game_state.enemy.on_dead{ @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is down!")}

        @game_state.enemy.on_use_skill{|skill, _| skill.sound != nil ? @sound.play_sound(skill.sound) : nil}

        self.decide_next_enemy_action
    end

    def set_use_audio(is_use_audio)
        @game_state.set_use_audio(is_use_audio)
    end

    def set_audio(volume)
        @game_state.set_audio(volume)
    end
    
    def request_choose_player
        @game_state.reset_state
        @menu_manager.change_menu(ChoosePlayerMenu.new(self))

        self
    end

    def back_to_main_menu
        @game_state.reset_state
        @menu_manager.change_menu(MainMenu.new(self))

        self
    end

    def back_to_play_menu
        @menu_manager.change_menu(PlayMenu.new(self))
        
        self
    end

    def go_to_choose_skill_menu
        @menu_manager.change_menu(ChooseSkillMenu.new(self))

        self
    end

    def go_to_inspecting_menu
        @menu_manager.change_menu(InspectingMenu.new(self))

        self
    end

    def go_to_settings_menu
        @menu_manager.change_menu(UserSettingsMenu.new(self))

        self
    end

    def logs
        @game_state.logs.logs
    end

    def quit_game
        @on_quit_game_listeners.emit()

        self
    end
end