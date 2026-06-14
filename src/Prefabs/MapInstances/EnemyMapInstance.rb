require "forwardable"
require "utils/Event"
require "Parents/MapInstance"
require "MapInstances/PlayerMapInstance"

class EnemyMapInstance < MapInstance
    extend Forwardable
    attr_reader :enemy,
        :on_enemy_death, :remove_on_enemy_death

    def_delegator :@on_enemy_death_listeners, :subscribe, :on_enemy_death
    def_delegator :@on_enemy_death_listeners, :unsubscribe, :remove_on_enemy_death

    # @param location_x [Integer] the x coordinate of this map instance
    # @param location_y [Integer] the y coordinate of this map instance
    # @param enemy [Creature] the enemy that this map instance represents
    def initialize(enemy, location_x = 0, location_y = 0)
        super(location_x, location_y)
        @enemy = enemy
        @on_enemy_death_listeners = Event.new
        

        @symbol = "▲".colorize(:red)
        
        @enemy.killable.on_death.subscribe{
            @symbol = "▲".colorize(:grey)
            @on_enemy_death_listeners.emit(self)
        }
    end

    # @param map_instance [MapInstance] the map instance that about to move to this map instance
    def on_move_to(map_instance)
        if @enemy.killable.is_dead?
            return
        end

        if map_instance.is_a? PlayerMapInstance
            fight = Fight.new(@enemy)
            enemy_fight = Fight.new(map_instance.player)

            # trigger fight
            map_instance.player.fightable.start_fight(fight)
            @enemy.fightable.start_fight(enemy_fight)
        end
    end

    def update(map)
        # # todo
        # map.get_pov(self, 3).each do |row|
        #     # check if there's player
        #     player_instance = row.find { |instance| instance.is_a? PlayerMapInstance }
        #     if player_instance
        #         # if found get closer
        #         # get the direction to move in
        #         unless player_instance.location_x == self.location_x
        #             direction = player_instance.location_x > self.location_x ? "right" : "left"
        #         else
        #             direction = player_instance.location_y > self.location_y ? "down" : "up"
        #         end

        #         map.move_instance(self, direction)
        #     end
        # end
    end
end