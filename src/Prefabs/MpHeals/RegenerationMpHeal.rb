require "Parents/ActionProfile/MpHeal"

class RegenerationMpHeal < MpHeal
    def initialize(healer)
        super(healer.nmpr.natural_mp_regen, false)
    end
end