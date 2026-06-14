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
require "Menu/MapMenu"
require "Menu/MapPauseMenu"
require "Menu/DefeatEnemyMenu"

require "Sounds/SelectSound"

class Game
    extend Forwardable

        attr_reader :player_list, :enemies_list, :menu_manager, :inspecting, :enemy_about_to_use, :on_quit_game, 
        :player, :enemy, :volume, :is_use_audio, :inspecting, :inspecting_player, :inspecting_enemy, :clear_inspecting, :current_turn, :player_map_instance

    def_delegators :@game_state, :player, :enemy, :volume, :is_use_audio, :inspecting, :inspect_player, :inspect_enemy, :clear_inspecting, :current_turn, :player_map_instance

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
        @on_quit_game_listeners = Event.new()
        
        @menu_manager.on_focus_next_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_focus_prev_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_select_left_current_element{@sound.play_sound(SelectSound.new())}
        @menu_manager.on_select_right_current_element{@sound.play_sound(SelectSound.new())}
    end

    # @param player [Creature] the player to be set as the current player
    def play_game(player)
        @game_state.set_player(player.new())

        @game_state.player.damageable.on_after_take_damage.subscribe{|damage|
            @game_state.logs.add_log("you received #{damage.amount_colorized} #{damage.damage_type} damage")
        }

        @game_state.player.skill_usable.on_before_use_skill.subscribe{|skill, target| 
            @game_state.logs.add_log("You use #{skill.name_colorized}")
        }

        # @param effect [Effect] the effect that was applied
        @game_state.player.effectable.on_after_effect_applied.subscribe {|effect| 
            @game_state.logs.add_log("You are affected by #{effect.display_name}")
        }

        # @param effect [Effect] the effect that was applied
        @game_state.player.effectable.on_after_remove_effect.subscribe {|effect|
            @game_state.logs.add_log("#{effect.display_name} on you has expired")
        }

        @game_state.player.healable.on_after_heal.subscribe {|heal_instance|
            @game_state.logs.add_log("You healed #{heal_instance.amount_colorized} HP")
        }

        @game_state.player.damageable.on_damage_miss.subscribe {|damage|
            @game_state.logs.add_log("You dodged the attack!")
        }

        @game_state.player.killable.on_death.subscribe {
            @game_state.logs.add_log("You have been slain!")
            @menu_manager.change_menu(YouDeadMenu.new(self))
        }

        # @param fight [Fight] the fight that was started
        @game_state.player.fightable.on_after_fight_start_listeners.subscribe{|fight|
            self.register_new_enemy(fight.with)
        }

        @menu_manager.change_menu(MapMenu.new(self))
    end

    def trigger_enemy_attack
        if @game_state.player == nil || @game_state.enemy == nil
            throw "Cannot trigger enemy attack when player or enemy is nil"
        end

        skill = @game_state.enemy.decide_next_action(@game_state.player)

        if skill == nil || skill == -1
            @game_state.enemy.end_turn
        else
            @game_state.enemy.use_skill(skill, @game_state.player)
        end
    end

    # @param enemy [Creature] the enemy to be registered
    def register_new_enemy(enemy)
        @game_state.set_enemy(enemy)

        # @param [Damage] damage
        @game_state.enemy.damageable.on_after_take_damage.subscribe{|damage| 
            @game_state.logs.add_log("You deal #{damage.amount_colorized} #{damage.damage_type} damage")
        }

        # @param skill [Skill] the skill that was used
        @game_state.enemy.skill_usable.on_before_use_skill.subscribe{|skill, target|
            @game_state.logs.add_log("Enemy use #{skill.name_colorized}")
        }

        # @param effect [Effect] the effect that was applied
        @game_state.enemy.effectable.on_after_effect_applied.subscribe{|effect|
            @game_state.logs.add_log("You inflict #{effect.name_colorized} on Enemy")
        }

        @game_state.enemy.effectable.on_after_remove_effect.subscribe{|effect|
            @game_state.logs.add_log("#{effect.name_colorized} on Enemy has expired")
        }

        @game_state.enemy.healable.on_after_heal.subscribe{|heal_instance|
            @game_state.logs.add_log("Enemy healed #{heal_instance.amount_colorized} HP")
        }

        @game_state.enemy.damage_avoid.on_damage_avoided.subscribe{|damage|
            @game_state.logs.add_log("Enemy dodged the attack!")
        }

        @game_state.enemy.killable.on_death.subscribe {
            @game_state.logs.add_log("Enemy is down!")
            self.go_to_defeat_enemy_menu(@game_state.enemy)
            @game_state.cleanup_enemy
            @game_state.player.fightable.end_fight
        }

        self.trigger_fight(@game_state.enemy)
    end

    def switch_turn
        if @game_state.current_turn == nil
            throw "Cannot switch turn when current turn is nil"
        end

        @game_state.current_turn.turnable.end_turn

        @game_state.set_current_turn(@game_state.current_turn == @game_state.enemy)

        @game_state.current_turn.turnable.start_turn
    end

    def start_enemy_turn
        self.switch_turn
        
        while @game_state.current_turn.decide_next_action(@game_state.player) != -1
            if @game_state.player.killable.is_dead?
                @menu_manager.change_menu(YouDeadMenu.new(self))
                return
            end
        end

        self.switch_turn
        @menu_manager.change_menu(PlayMenu.new(self))
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

    def go_to_map_menu
        @menu_manager.change_menu(MapMenu.new(self))

        self
    end

    def go_to_map_pause_menu
        @menu_manager.change_menu(MapPauseMenu.new(self))

        self
    end

    # param enemy [Creature] the enemy that the player is fighting
    def trigger_fight(enemy)
        @game_state.set_current_turn(true)

        @menu_manager.change_menu(PlayMenu.new(self))
    end

    def go_to_defeat_enemy_menu(enemy)
        @menu_manager.change_menu(DefeatEnemyMenu.new(self, enemy))
    end

    def logs
        @game_state.logs.logs
    end

    def quit_game
        @on_quit_game_listeners.emit()

        self
    end

    def map
        @game_state.map
    end

    def input_up
        @menu_manager.focus_prev_element
    end

    def input_down
        @menu_manager.focus_next_element
    end

    def input_left
        @menu_manager.select_left_current_element
    end

    def input_right
        @menu_manager.select_right_current_element
    end

    def input_enter
        @menu_manager.select_current_element
    end

    def input_escape
        @menu_manager.escape_menu
    end
end