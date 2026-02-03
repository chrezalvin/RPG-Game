require_relative "./GameState"
require_relative "./Prefabs/Creatures/Players/index"
require_relative "./Prefabs/Creatures/Enemies/index"
require_relative "./Prefabs/Menu/ChoosePlayerMenu"
require_relative "./Prefabs/Menu/PlayMenu"
require_relative "./Prefabs/Menu/MainMenu"
require "colorize"

class Game
    attr_reader :player_list, :enemies_list, :current_menu

    def initialize
        @game_state = GameState.new()
        @current_menu = MainMenu.new(self)
        @player_list = PlayersList.get_player_list
        @enemies_list = EnemiesList.get_enemies_list
    end

    def trigger_player_basic_attack
        if @game_state.player != nil && @game_state.enemy != nil
            damage = @game_state.player.basic_attack(@game_state.enemy)
            @game_state.logs.add_log("You hit #{@game_state.enemy.name} with a basic attack, dealing #{damage} damage")
        end
    end

    
    def play_game(player)
        @game_state.set_player(player.new())
        @game_state.set_enemy(@enemies_list.sample.new())
        @current_menu = PlayMenu.new(self)
    end

    def request_choose_player
        @current_menu = ChoosePlayerMenu.new(self)
    end

    def quit_game
        @game_state.flag_exit = true
    end

    # setters
    def reset_game
        @game_state.reset_state
    end
    
    def back_to_main_menu
        self.reset_game
        @current_menu = MainMenu.new(self)
    end

    def player
        @game_state.player
    end

    def enemy
        @game_state.enemy
    end

    def flag_exit
        @game_state.flag_exit
    end

    def logs
        @game_state.logs.logs
    end
end