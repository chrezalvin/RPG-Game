require "colorize"
require "Parents/MapInstance"

class PathMapInstance < MapInstance
    # @param location_x [Integer] the x coordinate of this map instance
    # @param location_y [Integer] the y coordinate of this map instance
    def initialize(location_x = 0, location_y = 0)
        super(location_x, location_y)
        @symbol = "•".colorize(:light_white)
    end

    # @param map_instance [MapInstance] the map instance that about to move to this map instance
    def on_move_to(map_instance)
        # allow move to this instance
        map_instance.location_x = self.location_x
        map_instance.location_y = self.location_y
    end

    def solid?
        false
    end
end