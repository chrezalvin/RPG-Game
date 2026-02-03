require_relative "./Prefabs/Menu/MenuElement"
require_relative "./Logs"
require_relative "./Prefabs/Menu/Menu"
require_relative "./Game"
require "colorize"

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
        sentence_length = sentence.length
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
        sentence_length = sentence.length
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

        if (@game.player != nil) && (@game.enemy) != nil
            print_fill("=")
            prints_bordered_line("#{@game.player.name}", "center", @box_width/2); prints_bordered_line("#{@game.enemy.name}", "center", @box_width/2); 
            printf("\n")
            prints_bordered_line("HP: #{@game.player.hp}", "left", @box_width / 2); prints_bordered_line("HP: #{@game.enemy.hp}", "left", @box_width / 2)
            printf("\n")
            prints_bordered_line("MP: #{@game.player.mp}", "left", @box_width / 2); prints_bordered_line("MP: #{@game.enemy.mp}", "left", @box_width / 2); 
            printf("\n")
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