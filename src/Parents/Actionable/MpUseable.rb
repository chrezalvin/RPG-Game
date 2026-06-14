require "Parents/Stats/Mp"
require "Parents/ActionProfile/MpUse"

class MpUseable
    attr_reader :on_before_use_mp, :on_after_use_mp

    # @param mp [Mp] the MP object of the creature
    def initialize(mp)
        throw "Error: mp must be an instance of Mp, got #{mp.class}" unless mp.is_a? Mp

        @mp = mp

        @on_before_use_mp = Event.new()
        @on_after_use_mp = Event.new()
    end

    # @param mp_use_instance [MpUse] the MP use instance to be applied to the creature
    # @return [Integer] the end final MP used after applying all effects and MP cost
    def use_mp(mp_use_instance)
        throw "Error: mp_use_instance must be an instance of MpUse, got #{mp_use_instance.class}" unless mp_use_instance.is_a? MpUse
        
        @on_before_use_mp.emit(mp_use_instance)

        @mp - mp_use_instance.mp_used

        @on_after_use_mp.emit(mp_use_instance)
    end
end