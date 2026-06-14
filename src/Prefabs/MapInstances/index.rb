require_relative "./ChestMapInstance"
require_relative "./HoleMapInstance"
require_relative "./PathMapInstance"
require_relative "./PlayerMapInstance"
require_relative "./EnemyMapInstance"
require_relative "./WallMapInstance"

class MapInstanceList
    @@map_instance_list = [
            ChestMapInstance,
            HoleMapInstance,
            PathMapInstance,
            PlayerMapInstance,
            EnemyMapInstance,
            WallMapInstance,
        ]

    def self.get_map_instance_list
        @@map_instance_list
    end

    # get the map instance class by its symbol
    # @param symbol [String] the symbol of the map instance class to get
    # @return [Class] the map instance class with the given symbol, or nil if not found
    def self.get_map_instance_by_symbol(symbol)
        @@map_instance_list.each do |map_instance_class|
            if map_instance_class.new().symbol == symbol
                return map_instance_class
            end
        end
        return nil
    end
end