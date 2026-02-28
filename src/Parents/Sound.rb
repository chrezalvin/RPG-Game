class Sound
    attr_reader :file_name, :speed, :relative_volume

    def initialize(file_name: "", speed: 1.0, relative_volume: 1.0)
        @file_name = file_name
        @speed = 1.0
        @relative_volume = 1.0
    end
end