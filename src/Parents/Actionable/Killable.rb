require "utils/Event"
require "Parents/Stats/Hp"

class Killable
    attr_reader :on_death

    # @param hp [Hp] the Hp instance of the creature
    def initialize(hp)
        throw "Error: hp must be an instance of Hp, got #{hp.class}" unless hp.is_a? Hp

        @hp = hp

        @is_dead = false

        @on_death = Event.new()

        @hp.on_hp_reached_zero.subscribe do
            @is_dead = true
            @on_death.emit()
        end
    end

    def is_dead?
        @is_dead
    end
end