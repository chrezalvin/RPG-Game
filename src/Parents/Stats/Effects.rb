require "utils/Event"
require "Parents/Action/Effect"

class Effects
    attr_reader :effects
    def initialize
        # @type [Array<Effect>] the list of effects
        @effects = []
    end

    # @param effect_class [Class] the class of the effect to be found
    def find_effect(effect_class)
        throw "Error: effect_class must be a Class, got #{effect_class.class}" unless effect_class.is_a? Class

        @effects.find { |effect| effect.is_a? effect_class }
    end
end