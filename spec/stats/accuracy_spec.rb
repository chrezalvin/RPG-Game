require "Parents/Stats/Accuracy"

RSpec.describe Accuracy do
	context "when initialized with accuracy 75" do
		accuracy_value = 75
		accuracy = Accuracy.new(accuracy: accuracy_value)

		after(:each) do
			accuracy_value = accuracy.accuracy
		end

		it 'expects accuracy to be set from constructor' do
			expect(accuracy.accuracy).to eq accuracy_value
		end

		it 'allows updating accuracy' do
			accuracy.accuracy = 10
			expect(accuracy.accuracy).to eq 10
		end
	end

	context "when initialized without a value" do
		acc = Accuracy.new

		it 'defaults accuracy to 0' do
			expect(acc.accuracy).to eq 0
		end
	end
end

