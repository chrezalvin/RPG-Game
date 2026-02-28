require_relative "./Viking"
require_relative "./Mage"
require_relative "./Joe"

class PlayersList
    @@players_list = [
        Viking,
        Mage
    ]

    @@players_list_test = [
        Joe
    ]

    def self.get_player_list
        @@players_list
    end

    def self.get_test_player_list
        @@players_list + @@players_list_test
    end
end