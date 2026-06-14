class Accuracy
        attr_reader :base_accuracy_modifiers, :accuracy_modifiers

        
        def initialize(amount: nil)
                @base_accuracy = amount || 0

                # @type [Array<Proc>]
                @base_accuracy_modifiers = []

                # @type [Array<Proc>]
                @accuracy_modifiers = []
        end
        
        # @return [String] the accuracy in colorized format, shows +/- when modified from base
        def accuracy_colorized
                accuracy = self.accuracy
                base_accuracy = self.base_accuracy
                dif = accuracy - base_accuracy

                if dif > 0
                        return "#{accuracy.to_s.colorize(:cyan)} (#{"+#{dif.to_s}".colorize(:green)})"
                elsif dif < 0
                        return "#{accuracy.to_s.colorize(:cyan)} (#{dif.to_s.colorize(:red)})"
                else
                        return accuracy.to_s
                end
        end

        def base_accuracy
                base_accuracy = @base_accuracy

                @base_accuracy_modifiers.each do |modifier|
                        base_accuracy = modifier.call(base_accuracy)
                end

                return base_accuracy.to_i
        end

        def accuracy
                accuracy = self.base_accuracy

                @accuracy_modifiers.each do |modifier|
                        accuracy = modifier.call(accuracy)
                end

                return accuracy.to_i
        end
end