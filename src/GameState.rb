require_relative "./Parents/Creature"
require_relative "./Parents/Menu"
require_relative "./Prefabs/Creatures/Enemies/Minotaur"
require_relative "./Prefabs/Menu/MainMenu"
require_relative "./Logs"

class GameState
    attr_reader :player, :enemy, :current_menu, :logs
    attr_accessor :flag_exit
    def initialize
        @player = nil
        @enemy = nil
        @logs = Logs.new()
        @flag_exit = false
    end

    def set_logs(logs)
        if logs.is_a? Logs
            @logs = logs
        end

        self
    end

    def set_enemy(enemy)
        if enemy.is_a? Creature
            @enemy = enemy

            @logs.add_log("A #{@enemy.name_colorized} challenged you to a duel!")
        end

        self
    end

    def set_player(player)
        if player.is_a? Creature
            @player = player

            @logs.add_log("You choose #{player.name_colorized}")
        end
    end

    def reset_state
        @player = nil
        @enemy = nil
        @logs.reset_logs
    end
end