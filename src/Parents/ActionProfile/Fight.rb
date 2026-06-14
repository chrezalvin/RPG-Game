class Fight
    attr_accessor :mode, :with
    @@fight_modes = ["normal", "ambush"]

    # @param with [Creature] the creature to fight against
    # @param mode [String] the mode of the fight, can be "normal" or "ambush"
    def initialize(with, mode = "normal")
        throw "Error: with must be an instance of Creature, got #{with.class}" unless with.is_a? Creature

        @mode = mode
        @with = with
    end
end