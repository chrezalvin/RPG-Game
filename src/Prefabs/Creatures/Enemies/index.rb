require_relative "./Minotaur"
require_relative "./NovaTheCat"
require_relative "./GiantSpider"
require_relative "./Mummy"
require_relative "./Vampire"

class EnemiesList
    @@enemies_list = [
            Minotaur,
            NovaTheCat,
            GiantSpider,
            Mummy,
            Vampire,
        ]

    def self.get_enemies_list
        @@enemies_list
    end
end