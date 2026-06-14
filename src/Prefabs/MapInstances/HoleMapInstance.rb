require "Parents/MapInstance"

class HoleMapInstance < MapInstance
    # @param location_x [Integer] the x coordinate of this map instance
    # @param location_y [Integer] the y coordinate of this map instance
    def initialize(location_x = 0, location_y = 0)
        super(location_x, location_y)
        @symbol = " "
    end
end