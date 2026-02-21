require_relative "./Viking"
require_relative "./Mage"

class PlayersList
    @@players_list = [
        Viking,
        Mage
    ]

    def self.get_player_list
        @@players_list
    end
end