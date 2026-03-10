require "json"
require "utils/GameData"

class GameSettings
    @@default_user_settings = {
        "use_audio": true,
        "preferred_volume_percentage": 100
    }
    def initialize(user_settings_file)
        @game_data = GameData.new(user_settings_file, @@default_user_settings)
    end

    def user_settings
        @game_data.game_data
    end

    def set_use_audio(is_use_audio)
        throw "Error: is_use_audio must be a boolean value" unless [true, false].include?(is_use_audio)
        @game_data.set_game_data("use_audio", is_use_audio)
    end

    def is_use_audio
        return @game_data.game_data["use_audio"]
    end

    def set_preferred_volume(volume)
        throw "Error: Volume must be between 0 and 100" if volume < 0 || volume > 100
        @game_data.set_game_data("preferred_volume_percentage", volume)
    end

    def preferred_volume
        return @game_data.game_data["preferred_volume_percentage"]
    end
end