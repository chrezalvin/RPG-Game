require "json"
require "utils/GameData"

class UserData
    @@default_user_data = {
        
    }
    def initialize(user_data_file)
        @game_data = GameData.new(user_data_file, @@default_user_data)
    end
end