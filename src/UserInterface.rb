require "Logs"
require "Game"
require "colorize"

require "Parents/MenuElement"
require "Parents/Menu"
require "Parents/Creature"

class UserInterface
    @@initial_box_width = 94
    def initialize(game)
        if game.is_a? Game
            @game = game
        end

        @box_width = @@initial_box_width
    end

    private def print_fill(fill)
        puts(fill * @box_width)
    end

    private def puts_bordered_line(sentence, align = "left", width = @box_width)
        sentence_length = sentence.gsub(/\e\[[0-9;]*m/, '').length
        case align
        when "left"
            puts("| " + sentence + (" " * (width - sentence_length - 3))  + "|")
        when "right"
            puts("|" + (" " * (width - sentence_length - 3)) + sentence + "|")
        when "center"
            puts("|" + (" " * ((width - sentence_length)/2)) + sentence + (" " * ((width - sentence_length)/2 - 1)) + "|")
        end
    end

    private def prints_bordered_line(sentence, align = "left", width = @box_width)
        sentence_length = sentence.gsub(/\e\[[0-9;]*m/, '').length
        case align
        when "left"
            printf("| " + sentence + (" " * (width - sentence_length - 3))  + "|")
        when "right"
            printf("|" + (" " * (width - sentence_length - 3)) + sentence + "|")
        when "center"
            printf("|" + (" " * ((width - sentence_length)/2)) + sentence + (" " * ((width - sentence_length)/2 - 1)) + "|")
        end
    end

    def print
        # top-border
        print_fill("=")
        puts_bordered_line("CHREZ RPG", "center")
        print_fill("=")

        if @game.logs != nil
            for log in @game.logs
                puts_bordered_line(log, "left")
            end
        end

        print_fill("=")

        if @game.current_menu != nil
            for menu in @game.current_menu.menu_list
                puts_bordered_line(menu, "left")
            end
        end

        if (@game.player != nil) && (@game.enemy != nil)
            print_fill("=")
            prints_bordered_line("#{@game.player.name_colorized}", "center", @box_width/2); 
            prints_bordered_line("#{@game.enemy.name_colorized}", "center", @box_width/2); 
            printf("\n")
            prints_bordered_line("HP: #{@game.player.current_hp}/#{@game.player.max_hp}", "left", @box_width / 2); 
            prints_bordered_line("HP: #{@game.enemy.current_hp}/#{@game.enemy.max_hp}", "left", @box_width / 2)
            printf("\n")
            prints_bordered_line("MP: #{@game.player.current_mp}/#{@game.player.max_mp}", "left", @box_width / 2); 
            prints_bordered_line("MP: #{@game.enemy.current_mp}/#{@game.enemy.max_mp}", "left", @box_width / 2); 
            printf("\n")
        end

        if @game.inspecting != nil
            inspecting = @game.inspecting
            buffsDebuffs = inspecting.effects.map{|effect| effect.name}.join(", ")

            

            print_fill("=")
            puts_bordered_line("#{inspecting.name}", "center")
            puts_bordered_line("", "left")
            puts_bordered_line("HP: #{inspecting.current_hp_colorized}/#{inspecting.max_hp_colorized}  MP: #{inspecting.current_mp_colorized}/#{inspecting.max_mp_colorized}", "left")
            puts_bordered_line("Atk: #{inspecting.atk_colorized}  Matk: #{inspecting.matk_colorized}", "left")
            puts_bordered_line("Natural HP Regen: #{inspecting.natural_hp_regen}", "left")
            puts_bordered_line("Natural MP Regen: #{inspecting.natural_mp_regen}", "left")
            puts_bordered_line("Buffs/Debuffs: #{buffsDebuffs}", "left")
        end

        print_fill("=")
        if @game.current_menu.current_selected != nil && @game.current_menu.current_selected.tooltip != nil
            puts_bordered_line(@game.current_menu.current_selected.tooltip)
        else
            puts_bordered_line("press up and down arrow key to select and Enter to confirm", "left")
        end
        print_fill("=")
    end
end