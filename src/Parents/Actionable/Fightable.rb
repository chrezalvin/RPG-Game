require "Parents/ActionProfile/Fight"

class Fightable
    attr_reader :on_before_fight_start_listeners, 
                :on_after_fight_start_listeners,
                :on_before_fight_end_listeners,
                :on_after_fight_end_listeners

    def initialize
        # @type [Fight, nil] the current fight instance representing the ongoing fight action, nil if no fight is currently happening
        @current_fight = nil

        @on_before_fight_start_listeners = Event.new()
        @on_after_fight_start_listeners = Event.new()

        @on_before_fight_end_listeners = Event.new()
        @on_after_fight_end_listeners = Event.new()
    end

    # @param fight_instance [Fight] the fight instance representing the fight action being performed
    def start_fight(fight_instance)
        throw "Error: fight_instance must be an instance of Fight, got #{fight_instance.class}" unless fight_instance.is_a? Fight
        @on_before_fight_start_listeners.emit(fight_instance)

        @current_fight = fight_instance

        @on_after_fight_start_listeners.emit(fight_instance)
    end

    def end_fight
        current_fight = @current_fight
        
        @on_before_fight_end_listeners.emit(current_fight)

        @current_fight = nil

        @on_after_fight_end_listeners.emit(current_fight)
    end
end