require "Parents/Stats/Mp"

RSpec.describe Mp do
    context "when initialized with current_mp 50 and max_mp 100" do
        current_mp = 50
        max_mp = 100
        mp = Mp.new(current_mp: current_mp, max_mp: max_mp)

        after(:each) do
            current_mp = mp.current_mp
        end

        it 'expects current_mp is valid' do
            expect(mp.current_mp).to eq current_mp
        end

        it 'expects max_mp is valid' do
            expect(mp.max_mp).to eq max_mp
        end

        it 'expects add_mp to increase current_mp' do
            mp.add_mp(20)
            expect(mp.current_mp).to eq current_mp + 20
        end

        it 'expects use_mp to decrease current_mp' do
            mp.use_mp(10)
            expect(mp.current_mp).to eq current_mp - 10
        end

        it 'expects mp cannot exceed max_mp' do
            mp.add_mp(999)
            expect(mp.current_mp).to eq max_mp
        end

        it 'expects on_mp_used to be emitted when use_mp is called' do
            func = -> emitted_amount { expect(emitted_amount).to eq 20 }
            mp.on_mp_used(func)

            mp.use_mp(20)

            mp.remove_on_mp_used(func)
        end

        it 'expects on_mp_added to be emitted when add_mp is called' do
            func = -> emitted_amount { expect(emitted_amount).to eq 20 }

            mp.on_mp_added(func)

            mp.add_mp(20)

            mp.remove_on_mp_added(func)
        end

        it 'expects on_mp_changed to be emitted when use_mp is called' do
            func = -> emitted_current_mp { expect(emitted_current_mp).to eq current_mp - 10 }

            mp.on_mp_changed(func)

            mp.use_mp(10)

            mp.remove_on_mp_changed(func)
        end

        it 'expects on_mp_changed to be emitted when add_mp is called' do
            func = -> emitted_current_mp { expect(emitted_current_mp).to eq current_mp + 10 }

            mp.on_mp_changed(func)

            mp.add_mp(10)

            mp.remove_on_mp_changed(func)
        end
    end
end