require "Parents/MapInstance"

class PlayerMapInstance < MapInstance
    # @param player [Creature] the player that this map instance represents
    # @param location_x [Integer] the x coordinate of this map instance
    # @param location_y [Integer] the y coordinate of this map instance
    def initialize(player, location_x = 0, location_y = 0)
        super(location_x, location_y)
 
        @player = player
        @symbol = "▲".colorize(:green)

        @on_being_ambushed_listener = Event.new()
        @on_attacking_enemy_listener = Event.new()
    end

    def on_interact(map)
         
    end

    # @param map_instance [MapInstance] the map instance that about to move to this map instance
    def on_move_to(map_instance)
        super(map_instance)

        # check if enemy
        if map_instance.is_a? EnemyMapInstance
            # trigger fight
            # map.trigger_player_fight(map_instance.enemy)
            @on_being_ambushed_listener.emit(map_instance.enemy)
        end
    end

    def player
        @player
    end
end