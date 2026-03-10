require "Parents/Stats/Hp"
require "Parents/Damage"
require "Parents/Heal"

RSpec.describe Hp do
    context "when initialized with current hp 50 and max hp 100" do
        current_hp = 50
        max_hp = 100
        hp = Hp.new(current_hp: current_hp, max_hp: max_hp)

        after(:each) do
            current_hp = hp.current_hp
        end

        it 'expects current hp is valid' do
            expect(hp.current_hp).to eq current_hp
        end

        it 'expects max hp is valid' do
            expect(hp.max_hp).to eq max_hp
        end

        it 'expects is_dead? to be false' do
            expect(hp.is_dead?).to eq false
        end

        it 'expects take_damage to reduce current hp' do
            damage = Damage.new(20, nil)

            hp.take_damage(damage)
            expect(hp.current_hp).to eq current_hp - damage.damage
        end

        it 'expects heal to increase current hp' do
            heal_instance = Heal.new(10, nil)

            hp.heal(heal_instance)
            expect(hp.current_hp).to eq current_hp + heal_instance.heal
        end

        it 'expects heal to not increase current hp above max hp' do
            heal_instance = Heal.new(999, nil)

            hp.heal(heal_instance)
            expect(hp.current_hp).to eq max_hp
        end

        it 'expects on_hp_changed to be emitted when take_damage is called' do
            damage = Damage.new(10, nil)
            
            func = lambda do |emitted_current_hp|
                expect(emitted_current_hp).to eq current_hp - damage.damage
            end

            hp.on_hp_changed(func)

            hp.take_damage(damage)

            hp.remove_on_hp_changed(func)
        end

        it 'expects on_dead to be emitted when take_damage reduces current hp to 0' do
            func = -> { expect(hp.is_dead?).to eq true }
            hp.on_dead(func)

            damage = Damage.new(999, nil)
            hp.take_damage(damage)

            hp.remove_on_dead(func)
        end

        it 'expects current hp to not go below 0' do
            expect(hp.current_hp).to eq 0
        end

        it 'expects is_dead? to be true when current hp is 0' do
            expect(hp.is_dead?).to eq true
        end
    end
end