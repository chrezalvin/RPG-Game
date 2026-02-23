require "io/console"
require "utils/Event"

class UserInput
    def initialize()
        @listen_up = Event.new()
        @listen_down = Event.new()
        @listen_left = Event.new()
        @listen_right = Event.new()
        @listen_enter = Event.new()
    end

    def register_up_listener(fcn)
        @listen_up.subscribe(fcn)
    end

    def register_down_listener(fcn)
        @listen_down.subscribe(fcn)
    end

    def register_left_listener(fcn)
        @listen_left.subscribe(fcn)
    end

    def register_right_listener(fcn)
        @listen_right.subscribe(fcn)
    end

    def register_enter_listener(fcn)
        @listen_enter.subscribe(fcn)
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
        end
    end
end