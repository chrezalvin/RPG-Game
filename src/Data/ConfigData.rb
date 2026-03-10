require "json"
require "utils/GameData"

class ConfigData
    @@default_config_data = {
        "user_data_folder": "data/",
        "audio_folder": "assets/sounds",
        "current_version": "v0.5.0",
        "developer_mode": true
    }
    def initialize(config_data_file)
        @game_data = GameData.new(config_data_file, @@default_config_data)
    end

    def user_data_base_folder
        return @game_data.game_data["user_data_folder"]
    end

    def audio_base_folder
        return @game_data.game_data["audio_folder"]
    end

    def current_version
        return @game_data.game_data["current_version"]
    end

    def is_developer_mode
        return @game_data.game_data["developer_mode"]
    end
end