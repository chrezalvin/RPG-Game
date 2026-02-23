class GameData
    attr_reader :game_data

    def initialize(game_data_file, default_game_data)
        @default_game_data = default_game_data

        @game_data_file = game_data_file
        @game_data = default_game_data

        self.load_game_data
    end

    def reset_game_data
        @game_data = @default_game_data
        self.save_game_data
    end

    def load_game_data
        if self.check_if_game_data_exists
            @game_data = JSON.parse(File.read(@game_data_file))
        else
            self.save_game_data
        end
    end

    def save_game_data
        File.write(@game_data_file, JSON.pretty_generate(@game_data))
    end

    def set_game_data(game_data_key, game_data_value)
        @game_data[game_data_key] = game_data_value

        self.save_game_data
    end

    private def check_if_game_data_exists
        return File.exist?(@game_data_file)
    end
end