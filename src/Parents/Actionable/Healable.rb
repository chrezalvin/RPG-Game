require "Parents/Stats/Hp"
require "Parents/ActionProfile/Heal"

class Healable
    attr_reader :on_before_heal, :on_after_heal

    # @param hp [Hp] the HP instance of the creature that can be healed
    def initialize(hp)
        throw "Error: hp must be an instance of Hp, got #{hp.class}" unless hp.is_a? Hp
        @hp = hp

        @on_before_heal = Event.new()
        @on_after_heal = Event.new()
    end

    # @param heal_instance [Heal] the heal instance to be applied to the creature
    # @return [Heal] the end final heal instance after applying all effects and healing bonuses
    def heal(heal_instance)
        throw "Error: healInstance must be an instance of Heal, got #{heal_instance.class}" unless heal_instance.is_a? Heal
        
        @on_before_heal.emit(heal_instance)

        @hp + heal_instance.heal

        @on_after_heal.emit(heal_instance)
    end
end