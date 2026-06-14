require 'colorize'
require 'forwardable'
require 'utils/Event'

require "Parents/MapInstance"
require "Prefabs/MapInstances/PathMapInstance"
require "Prefabs/MapInstances/ShadowMapInstance"
require "Prefabs/MapInstances/PlayerMapInstance"

class Map extend Forwardable
    attr_reader :map_width, :map_height, :player_instance

    def initialize()
        @pov_radius = 5

        # @type [Integer] the width of the map
        @map_width = 1

        # @type [Integer] the height of the map
        @map_height = 1

        # @type [Array<MapInstance>] 1D array of map instances representing the static map
        @map = Array.new(1){PathMapInstance.new()}

        # @type [Array<MapInstance>]
        @instances = [@player_instance]
    end

    # @param instance [MapInstance] the map instance to move
    # @param direction [String] the direction to move the instance, can be "up", "down", "left", or "right"
    def move_instance(instance, direction)
        move_coord = case direction
        when "up"
            [instance.location_x, (instance.location_y - 1).clamp(0, @map_height - 1)]
        when "down"
            [instance.location_x, (instance.location_y + 1).clamp(0, @map_height - 1)]
        when "left"
            [(instance.location_x - 1).clamp(0, @map_width - 1), instance.location_y]
        when "right"
            [(instance.location_x + 1).clamp(0, @map_width - 1), instance.location_y]
        end

        # check instance on new location
        move_instance = get_instance_at_location(move_coord[0], move_coord[1])
        move_instance.on_move_to(instance)

        if instance.is_a? PlayerMapInstance
            self.update_all_instances
        end
    end

    # get the active or static map instances at the given location
    # @param x [Integer] the x coordinate of the location to get the instance at
    # @param y [Integer] the y coordinate of the location to get the instance at
    # @return [MapInstance, nil] map instance at the given location, could be nil if there's no instance at the location
    private def get_instance_at_location(x, y)
        # prefer active instances over static instances, if there's an active instance
        found_instances_active = @instances.find { |instance| instance.location_x == x && instance.location_y == y }
        return found_instances_active unless found_instances_active.nil?

        found_instances_static = @map.find { |instance| instance.location_x == x && instance.location_y == y }
        return found_instances_static
    end

    # @param map_instance [MapInstance] the map instance
    # @param radius [Integer] the radius of the point of view
    # @return [MapInstance[][]] a 2D array of map instances representing the instance's point of view
    def get_pov(map_instance, radius = @pov_radius)
        start_y = [(map_instance.location_y - @pov_radius).to_i, 0].max
        end_y   = [(map_instance.location_y + @pov_radius).to_i, @map_height - 1].min

        start_x = [(map_instance.location_x - @pov_radius).to_i, 0].max
        end_x   = [(map_instance.location_x + @pov_radius).to_i, @map_width - 1].min

        # construct a pov 2D array of map instances
        # @type [Array<Array<MapInstance, nil>>] 
        map = Array.new(end_y - start_y + 1){Array.new(end_x - start_x + 1){ShadowMapInstance.new(0, 0)}}

        px = map_instance.location_x
        py = map_instance.location_y

        (start_y..end_y).each do |y|
            (start_x..end_x).each do |x|
                next if distance(px, py, x, y) > radius

                if visible?(px, py, x, y)
                    instance = self.get_instance_at_location(x, y)
                    map[y - start_y][x - start_x] = instance if instance
                end
            end
        end

        return map
    end

    # calculate the distance between two points
    # @param x1 [Integer] the x coordinate of the first point
    # @param y1 [Integer] the y coordinate of the first point
    # @param x2 [Integer] the x coordinate of the second point
    # @param y2 [Integer] the y coordinate of the second point
    private def distance(x1, y1, x2, y2)
        Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
    end

    # check if two points are visible to each other
    # @param x0 [Integer] the x coordinate of the first point
    # @param y0 [Integer] the y coordinate of the first point
    # @param x1 [Integer] the x coordinate of the second point
    # @param y1 [Integer] the y coordinate of the second point
    private def visible?(x0, y0, x1, y1)
        dx = (x1 - x0).abs
        dy = (y1 - y0).abs

        sx = x0 < x1 ? 1 : -1
        sy = y0 < y1 ? 1 : -1

        err = dx - dy

        loop do
            return false if blocking?(x0, y0) && !(x0 == x1 && y0 == y1)

            break if x0 == x1 && y0 == y1

            e2 = 2 * err

            if e2 > -dy
            err -= dy
            x0 += sx
            end

            if e2 < dx
            err += dx
            y0 += sy
            end
        end

        true
    end

    # check if the given location is blocking the view, this is used in the visible? method to determine if a location is blocking the view
    # @param x [Integer] the x coordinate of the location to check
    # @param y [Integer] the y coordinate of the location to check
    # @return [Boolean] true if the location is blocking the view, false if it's not blocking the view
    private def blocking?(x, y)
        instance = self.get_instance_at_location(x, y)
        unless instance.nil? 
            return instance.solid?
        end

        return true
    end

    # add a map instance to the map, may fail if there's already an instance at the location of the given instance
    # @param instance [MapInstance] the map instance to add to the map
    # @return [MapInstance, nil] the given instance if it was successfully added to the map, nil if it failed to add the instance to the map
    def add_instance(instance)
        # check if instance is already in the map
        if @instances.any? { |i| i.location_x == instance.location_x && i.location_y == instance.location_y }
            return nil
        end

        @instances << instance

        return instance
    end

    # remove a map instance from the map
    # @param instance [MapInstance] the map instance to remove from the map
    def remove_instance(instance)
        @instances.delete(instance)
    end

    # replace a map instance in the map with another map instance
    # @param old_instance [MapInstance] the map instance to replace
    # @param new_instance [MapInstance] the map instance to replace with
    def replace_instance(old_instance, new_instance)
        remove_instance(old_instance)
        add_instance(new_instance)
    end

    # replace static map instance at the location of the given instance with the given instance, this should only be called when the player moves to a new location and the static map instance at that location needs to be replaced with the player instance
    # @param instance [MapInstance] the map instance to replace
    protected def replace_static_map_with_instance(instance)
        @map.delete_if { |map_instance| map_instance.location_x == instance.location_x && map_instance.location_y == instance.location_y }

        @map << instance
    end

    # fill the map with static map instances, this should only be called once at the start of the game
    # @param instance_class [Class] the class of the map instance to fill the map with, this should be a subclass of MapInstance
    protected def fill_static_map_with_instance(instance_class)
        for y in 0...@map_height
            for x in 0...@map_width
                instance = instance_class.new(x, y)
                @map << instance
            end
        end
    end

    protected def update_all_instances
        @instances.each { |instance| instance.update(self) }
        @map.each { |instance| instance.update(self) }
    end
end