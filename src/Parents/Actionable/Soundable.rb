require "utils/Event"
require "utils/SoundPlayer"
require "Parents/ActionProfile/Sound"

class Soundable
    attr_reader :on_before_make_sound, :on_after_make_sound

    # @param sound_player [SoundPlayer] the SoundPlayer instance responsible for playing sounds
    def initialize(sound_player)
        throw "Error: sound_player must be an instance of SoundPlayer, got #{sound_player.class}" unless sound_player.is_a? SoundPlayer
        
        @sound_player = sound_player

        @on_before_make_sound = Event.new()
        @on_after_make_sound = Event.new()
    end

    # @param sound [Sound] the Sound instance representing the sound to be made
    def make_sound(sound)
        throw "Error: sound must be an instance of Sound, got #{sound.class}" unless sound.is_a? Sound

        @on_before_make_sound.emit(sound)

        @sound_player.play_sound(sound)

        @on_after_make_sound.emit(sound)
    end
end