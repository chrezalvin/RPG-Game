require_relative "./Viking"

class PlayersList
    @@players_list = [
        Viking
    ]

    def self.get_player_list
        @@players_list
    end
end