require "Parents/Map"

require "Prefabs/MapInstances/PathMapInstance"
require "Prefabs/MapInstances/PlayerMapInstance"
require "Prefabs/MapInstances/WallMapInstance"
require "Prefabs/MapInstances/ChestMapInstance"
require "Prefabs/MapInstances/EnemyMapInstance"

class MapLevelDefault < Map
    def initialize()
        super()

        layout = [
            "#••#########################################",
            "#••#••••••••••••#••••••••••••••••••••••••••#",
            "#••#••••••••••••#••••••••••••••••••••••••••#",
            "#••#••••••••••••#••••••••••••••••••••••••••#",
            "#••#••••••••••••#••••••••••••••••••••••••••#",
            "#••###•###################•#################",
            "#••••••••••••••••••••••••••#•••••••••••••••#",
            "#••••••••••••••••••••••••••#•••••••••••••••#",
            "#•##############•••••••••••#•••••••••••••••#",
            "#••••••••••••••#•••••••••••#•••••••••••••••#",
            "#••••••••••••••#•••••••••••#•••••••••••••••#",
            "#••••••••••••••#••••••••••••••••••••••••••••",
            "############################################",
        ]

        @map_height = layout.length
        @map_width = layout[0].length
        @entrance_location = [1, 0]

        for y in 0...layout.length
            for x in 0...layout[y].length
                case layout[y][x]
                when "#"
                    self.replace_static_map_with_instance(WallMapInstance.new(x, y))
                when "•"
                    self.replace_static_map_with_instance(PathMapInstance.new(x, y))
                end
            end
        end

        enemy_instances = [
            EnemyMapInstance.new(Minotaur.new(), 2, 7),
            EnemyMapInstance.new(Mummy.new(), 4, 1),
            EnemyMapInstance.new(NovaTheCat.new(), 12, 3),
        ]

        enemy_instances.each do |enemy_instance|
            enemy_instance.on_enemy_death{
                self.remove_instance(enemy_instance)
            }
        end

        @instances = enemy_instances
    end

    # adds a map instance to the entrance of the map
    # @param instance [MapInstance] the map instance to add to the map
    def add_instance(instance)
        instance.location_x = @entrance_location[0]
        instance.location_y = @entrance_location[1]
        @instances << instance
    end
end