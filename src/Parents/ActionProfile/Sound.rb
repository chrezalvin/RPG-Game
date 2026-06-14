require "utils/SoundPlayer"

class Sound
    attr_reader :file_name, :speed, :relative_volume

    # @param file_name [String] the relative path to the sound file
    # @param speed [Float] the speed at which the sound should be played (default: 1.0)
    # @param relative_volume [Float] the relative volume of the sound (default: 1.0)
    def initialize(file_name: "", speed: 1.0, relative_volume: 1.0)
        @file_name = file_name
        @speed = 1.0
        @relative_volume = 1.0
    end

    # @param sound_player [SoundPlayer] the sound player to play the sound
    def make_sound(sound_player)
        throw "Error: sound_player must be an instance of SoundPlayer, got #{sound_player.class}" unless sound_player.is_a? SoundPlayer

        sound_player.play_sound(self)
    end
end