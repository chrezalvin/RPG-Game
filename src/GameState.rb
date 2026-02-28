require "Logs"
require "forwardable"
require "Data/GameSettings"
require "Data/UserData"

require "Parents/Creature"
require "Parents/Menu"

require "Creatures/Enemies/Minotaur"
require "Menu/MainMenu"

class GameState extend Forwardable
    attr_reader :player, :enemy, :current_menu, :logs, :inspecting,
        :volume, :is_use_audio

    def_delegator :@game_settings, :preferred_volume, :volume
    def_delegator :@game_settings, :is_use_audio, :is_use_audio

    def initialize(user_data_folder)
        @game_settings = GameSettings.new(user_data_folder + "settings.json")
        @user_data = UserData.new(user_data_folder + "user_data.json")
        
        @player = nil
        @enemy = nil
        @inspecting = nil
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
            @enemy = enemy

            @logs.add_log("A #{@enemy.name_colorized} challenged you to a duel!")
        end

        self
    end

    def set_player(player)
        if player.is_a? Creature
            @player = player

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
        @logs.reset_logs
    end
end