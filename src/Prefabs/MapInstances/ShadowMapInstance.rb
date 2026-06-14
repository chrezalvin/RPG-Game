require "Parents/MapInstance"

class ShadowMapInstance < MapInstance
    # @param x [Integer] the x coordinate of this map instance
    # @param y [Integer] the y coordinate of this map instance
    def initialize(x, y)
        super(x, y)
        # @symbol = "•".colorize(:light_grey)
        @symbol = " "
    end
end