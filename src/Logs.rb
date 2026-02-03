class Logs
    def initialize(initial_length = 10)
        @logs_length = initial_length
        @logs = Array.new(@logs_length, "")
    end

    def add_log(log)
        @logs.unshift(log)
        @logs.pop
        self
    end

    def logs
        @logs.reverse
    end

    def reset_logs
        @logs = Array.new(@logs_length, "")
    end
end