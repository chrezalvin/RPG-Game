require_relative "./Minotaur"
require_relative "./NovaTheCat"

class EnemiesList
    @@enemies_list = [
            Minotaur,
            NovaTheCat
        ]

    def self.get_enemies_list
        @@enemies_list
    end
end