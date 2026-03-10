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
require "Menu/InspectSkillMenu"
require "Menu/InspectEffectMenu"

require "Sounds/SelectSound"

class Game
    extend Forwardable

    attr_reader :player_list, :enemies_list, :menu_manager, :inspecting, :enemy_about_to_use, :on_quit_game, :player_turns, :enemy_turns,
        :player, :enemy, :volume, :is_use_audio, :inspecting, :inspecting_player, :inspecting_enemy, :clear_inspecting

    def_delegators :@game_state, :player, :enemy, :volume, :is_use_audio, :inspecting, :inspect_player, :inspect_enemy, :clear_inspecting

    def_delegator :@on_quit_game_listeners, :subscribe, :on_quit_game

    # @param config_data [ConfigData] The configuration data for the game
    def initialize(config_data)
        @game_state = GameState.new(config_data.user_data_base_folder)
        @menu_manager = MenuManager.new(MainMenu.new(self))
        @player_list = config_data.is_developer_mode ? PlayersList.get_test_player_list : PlayersList.get_player_list
        @enemies_list = EnemiesList.get_enemies_list
        @sound = SoundPlayer.new(config_data.audio_base_folder, @game_state)

        # @type [Integer, nil] the index of the skill that the enemy is about to use, nil if the enemy is not about to use any skill
        @enemy_about_to_use_idx = nil

        @player_turns = 0
        @enemy_turns = 0

        @on_quit_game_listeners = Event.new()
        
        @menu_manager.on_focus_next_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_focus_prev_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_select_left_current_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_select_right_current_element{@sound.play_sound(SelectSound.new())}
    end

    def initiate_skill(skill_idx)
        if @game_state.player == nil || @game_state.enemy == nil
            return
        end

        if @player_turns > 0
            @player_turns -= 1
            @game_state.player.use_skill(skill_idx, @game_state.enemy)

            if @game_state.enemy.is_dead?
                self.register_new_enemy
            end

            if @player_turns == 0
                while @enemy_turns > 0 && !@game_state.player.is_dead?
                    self.trigger_enemy_attack
                    self.decide_next_enemy_action
                    @enemy_turns -= 1
                end

                self.get_turns
            end
        end

        if @game_state.player.is_dead?
            @menu_manager.change_menu(YouDeadMenu.new(self))
        else
            @menu_manager.change_menu(PlayMenu.new(self))
        end
    end

    def trigger_enemy_attack
        if @game_state.player != nil && @game_state.enemy != nil
            @game_state.enemy.use_skill(@enemy_about_to_use_idx, @game_state.player)
        end
    end
    
    def play_game(player)
        @game_state.set_player(player.new())

        @game_state.player.on_take_damage{|damage| @game_state.logs.add_log("you received #{damage.amount_colorized} #{damage.damage_type} damage")}
        @game_state.player.on_use_skill{|skill, target| @game_state.logs.add_log("You used #{skill.name_colorized}")}
        @game_state.player.on_effect_applied{|effect| @game_state.logs.add_log("You are affected by #{effect.name_colorized}")}
        @game_state.player.on_effect_expired{|effect| @game_state.logs.add_log("#{effect.name_colorized} on you has expired")}
        @game_state.player.on_heal(lambda{|heal_instance| @game_state.logs.add_log("You healed #{heal_instance.amount_colorized} HP")})
        @game_state.player.on_creature_make_sound{|sound| @sound.play_sound(sound)}
        @game_state.player.on_damage_miss{|damage| @game_state.logs.add_log("You dodged the attack!")}
        @game_state.player.on_dead{@game_state.logs.add_log("You have been slain!")}
        
        self.register_new_enemy

        @menu_manager.change_menu(PlayMenu.new(self))
    end

    def get_turns
        @player_turns = @game_state.player.speed.calculate_turns(@game_state.enemy)
        @enemy_turns = @game_state.enemy.speed.calculate_turns(@game_state.player)
    end

    def decide_next_enemy_action
        if @game_state.enemy != nil && @game_state.player != nil
            enemy = @game_state.enemy
            player = @game_state.player

            @enemy_about_to_use_idx = enemy.decide_next_action(player)
            skill = enemy.skill(@enemy_about_to_use_idx)

            @game_state.logs.add_log("#{enemy.name_colorized} is preparing to use #{skill.name_colorized}!")
        end
    end

    def register_new_enemy
        @game_state.set_enemy(@enemies_list.sample.new())

        @game_state.enemy.on_take_damage{|damage| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} received #{damage.amount_colorized} #{damage.damage_type} damage")}
        @game_state.enemy.on_use_skill{|skill, target| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} used #{skill.name_colorized}")}
        @game_state.enemy.on_effect_applied{|effect| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is affected by #{effect.name_colorized}")}
        @game_state.enemy.on_effect_expired{|effect| @game_state.logs.add_log("#{effect.name_colorized} on #{@game_state.enemy.name_colorized} has expired")}
        @game_state.enemy.on_heal{|heal_instance| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} healed #{heal_instance.amount_colorized} HP")}
        @game_state.enemy.on_dead{ @game_state.logs.add_log("#{@game_state.enemy.name_colorized} is down!")}
        @game_state.enemy.on_damage_miss{|damage| @game_state.logs.add_log("#{@game_state.enemy.name_colorized} dodged the attack!")}
        @game_state.enemy.on_creature_make_sound{|sound| @sound.play_sound(sound)}

        self.decide_next_enemy_action
        self.get_turns
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

    def go_to_skill_inspecting_menu
        @menu_manager.change_menu(InspectSkillMenu.new(self))

        self
    end

    def go_to_effect_inspecting_menu
        @menu_manager.change_menu(InspectEffectMenu.new(self))

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