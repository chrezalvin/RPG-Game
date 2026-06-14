require "Logs"
require "forwardable"
require "Data/GameSettings"
require "Data/UserData"

require "Parents/Creature"
require "Parents/Menu"
require "Parents/Stats/Turn"

require "Creatures/Enemies/Minotaur"
require "Menu/MainMenu"
require "Prefabs/MapLevel/MapLevelDefault"
require "Prefabs/MapInstances/PlayerMapInstance"

class GameState extend Forwardable
    attr_reader :player, :enemy, :current_menu, :logs, :inspecting, :current_turn, :map, :player_map_instance,
        :volume, :is_use_audio

    def_delegator :@game_settings, :preferred_volume, :volume
    def_delegator :@game_settings, :is_use_audio, :is_use_audio

    def initialize(user_data_folder)
        @game_settings = GameSettings.new(user_data_folder + "settings.json")
        @user_data = UserData.new(user_data_folder + "user_data.json")
        
        # @type [Creature]
        @player = nil

        # @type [PlayerMapInstance]
        @player_map_instance = nil
        
        # @type [Creature]
        @enemy = nil

        # @type [Creature]
        @inspecting = nil

        # @type [Creature, nil]
        @current_turn = nil

        # @type [Map]
        @map = nil

        @logs = Logs.new()
    end

    def set_logs(logs)
        if logs.is_a? Logs
            @logs = logs
        end

        self
    end

    def set_enemy(enemy)
        if enemy.is_a? Creature
            @is_exploring = false
            @enemy = enemy

            @logs.add_log("A #{@enemy.name_colorized} challenged you to a duel!")
        end

        self
    end

    def cleanup_enemy()
        @enemy = nil
        @is_exploring = true
    end

    def set_player(player)
        if player.is_a? Creature
            @player = player
            @map = MapLevelDefault.new()
            @player_map_instance = PlayerMapInstance.new(player)
            @map.add_instance(@player_map_instance)

            @logs.add_log("You choose #{player.name_colorized}")
        end
    end

    def inspect_player
        @inspecting = @player
    end

    def inspect_enemy
        @inspecting = @enemy
    end

    def clear_inspecting
        @inspecting = nil
    end

    # @param from [Creature] the creature whose turns are being calculated
    # @param against [Creature] the creature against which the turns are being calculated
    protected def get_turns(from, against)
        from.speed.calculate_turns(against)
    end

    def set_current_turn(is_player)
        if is_player
            @current_turn = @player
        else
            @current_turn = @enemy
        end

        @current_turn.turns.set_turn(0)
        @current_turn.turns + get_turns(@current_turn, is_player ? @enemy : @player)
    end

    def set_audio(volume)
        @game_settings.set_preferred_volume(volume)
        @volume = volume
    end

    def set_use_audio(is_use_audio)
        @game_settings.set_use_audio(is_use_audio)
        @is_use_audio = is_use_audio
    end

    def reset_state
        @player = nil
        @enemy = nil
        @inspecting = nil
        @player_map_instance = nil
        @current_turn = nil
        @map = nil
        @logs.reset_logs
    end
end