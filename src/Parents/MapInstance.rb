require "Parents/Map"

class MapInstance
    attr_accessor :location_x, :location_y
    attr_reader :symbol, :priority

    # @param location_x [Integer] the x coordinate of this map instance
    # @param location_y [Integer] the y coordinate of this map instance
    # @param get_pov [Proc] a proc that takes in the map instance and return whether this map instance is in the player's pov, if nil, this map instance will always be in the player's pov
    def initialize(location_x = 0, location_y = 0, get_pov = nil)
        # @type [String] the symbol to represent on the map
        @symbol = "."
        
        # @type [Integer] the priority of this map instance, higher priority instances will be rendered on top of lower priority ones
        @priority = 0

        @get_pov = nil

        @location_x = location_x
        @location_y = location_y
    end

    # @param map [Map] the map that this map instance is in
    def update(map)
        throw "Error: map is not of object Map, map is #{map.class}" unless map.is_a? Map
    end

    # @param map [MapInstance] the map instance that about to move to this map instance
    def on_move_to(map_instance)
        throw "Error: map_instance is not of object MapInstance, map_instance is #{map_instance.class}" unless map_instance.is_a? MapInstance
        # do nothing by default
    end

    # return whether this map instance is solid
    def solid?
        false
    end
end