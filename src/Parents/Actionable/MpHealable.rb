require "Parents/Stats/Mp"
require "Parents/ActionProfile/MpHeal"

class MpHealable
    attr_reader :on_before_mp_heal, :on_after_mp_heal

    # @param mp [Mp] the MP instance of the creature
    def initialize(mp)
        throw "Error: mp must be an instance of Mp, got #{mp.class}" unless mp.is_a? Mp

        @mp = mp

        @on_before_mp_heal = Event.new()
        @on_after_mp_heal = Event.new()
    end

    # @param mp_heal_instance [MpHeal] the MP heal instance to be applied to the creature
    def heal_mp(mp_heal_instance)
        throw "Error: mp_heal_instance must be an instance of MpHeal, got #{mp_heal_instance.class}" unless mp_heal_instance.is_a? MpHeal
        
        @on_before_mp_heal.emit(mp_heal_instance)

        @mp + mp_heal_instance.mp_heal

        @on_after_mp_heal.emit(mp_heal_instance)
    end
end