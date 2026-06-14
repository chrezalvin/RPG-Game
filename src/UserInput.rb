require "forwardable"

require "io/console"
require "utils/Event"

class UserInput extend Forwardable
    attr_reader :on_up, :on_down, :on_left, :on_right, :on_enter, :on_space, :on_esc

    def_delegator :@listen_up, :subscribe, :on_up
    def_delegator :@listen_down, :subscribe, :on_down
    def_delegator :@listen_left, :subscribe, :on_left
    def_delegator :@listen_right, :subscribe, :on_right
    def_delegator :@listen_enter, :subscribe, :on_enter
    def_delegator :@listen_space, :subscribe, :on_space
    def_delegator :@listen_esc, :subscribe, :on_esc

    def initialize()
        @listen_up = Event.new()
        @listen_down = Event.new()
        @listen_left = Event.new()
        @listen_right = Event.new()
        @listen_enter = Event.new()
        @listen_space = Event.new()
        @listen_esc = Event.new()
    end

    def get_arrow_input
        user_input = STDIN.getch

        if user_input.bytes == [224, 80]
            @listen_down.emit()
        elsif user_input.bytes == [224, 72]
            @listen_up.emit()
        elsif user_input.bytes == [13]
            @listen_enter.emit()
        elsif user_input.bytes == [224, 77]
            @listen_right.emit()
        elsif user_input.bytes == [224, 75]
            @listen_left.emit()
        elsif user_input.bytes == [32]
            @listen_space.emit()
        elsif user_input.bytes == [27]
            @listen_esc.emit()
        end
    end
end