class Accuracy
    attr_accessor :accuracy

    def initialize(accuracy: nil)
        @accuracy = accuracy || 0
    end
end