require "io/console"

class UserInput
    def initialize(
        up_listeners = [],
        down_listeners = [],
        left_listeners = [],
        right_listeners = [],
        enter_listeners = []
    )
        @listen_up = up_listeners
        @listen_down = down_listeners
        @listen_left = left_listeners
        @listen_right = right_listeners
        @listen_enter = enter_listeners
    end

    def register_up_listener(fcn)
        @listen_up.push(fcn)
    end

    def register_down_listener(fcn)
        @listen_down.push(fcn)
    end

    def register_left_listener(fcn)
        @listen_left.push(fcn)
    end

    def register_right_listener(fcn)
        @listen_right.push(fcn)
    end

    def register_enter_listener(fcn)
        @listen_enter.push(fcn)
    end

    private def trigger_all_fcn_in_array(fcns)
        fcns.each{|fcn| fcn.call}
    end

    def get_arrow_input
        user_input = STDIN.getch

        if user_input.bytes == [224, 80]
            trigger_all_fcn_in_array(@listen_down)
        elsif user_input.bytes == [224, 72]
            trigger_all_fcn_in_array(@listen_up)
        elsif user_input.bytes == [13]
            trigger_all_fcn_in_array(@listen_enter)
        end
    end
end