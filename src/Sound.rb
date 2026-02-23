require "gosu"

class Sound < Gosu::Window
  def initialize(base_path = "assets/sounds/")
    super(640, 480)
    self.caption = "Sound Player"

    @base_path = base_path
  end

  def play_sound(file_name, volume = 1.0, speed = 1.0)
    path = convert_to_sound_path(file_name)

    @sound = Gosu::Sample.new(path)
    @sound.play(volume = volume, speed = speed, looping = false)
  end

  def convert_to_sound_path(relative_path)
    return @base_path + relative_path
  end
end