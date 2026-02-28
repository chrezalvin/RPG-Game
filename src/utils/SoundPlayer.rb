require "gosu"

require "Parents/Sound"
require "GameState"

class SoundPlayer < Gosu::Window
  # @param base_path [String] The base path to the audio files
  # @param sound_settings [GameState] The game state containing the sound settings
  def initialize(base_path, sound_settings)
    super(640, 480)
    self.caption = "Sound Player"

    @sound_settings = sound_settings

    @base_path = base_path
  end

  # Play a sound effect
  # @param sound [Sound] The sound effect to play
  def play_sound(sound)
    throw "Error: sound must be an instance of Sound" unless sound.is_a?(Sound)

    return if @sound_settings.is_use_audio == false

    path = convert_to_sound_path(sound.file_name)

    volume = @sound_settings.volume / 100.0 * sound.relative_volume

    @sound = Gosu::Sample.new(path)
    @sound.play(volume, sound.speed, looping = false)
  end

  def convert_to_sound_path(relative_path)
    return @base_path + relative_path
  end
end