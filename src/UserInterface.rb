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

    # Apply elipsis to the sentence if it is too long to fit in the box
    # @params sentence [String] the sentence to be displayed
    # @params width [Integer] the width of the box, if the sentence is too
    # @params additional_info [String] the additional information to be displayed after the elipsis
    private def apply_elipsis(sentence, width, additional_info = "")
        reduce_length = width - 4 - additional_info.length

        if sentence.length > reduce_length
            return sentence[0...reduce_length] + "..." + additional_info
        else
            return sentence
        end
    end

    private def print_fill(fill)
        puts(fill * @box_width)
    end

    # @param sentence [String] the sentence to be displayed
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

    # @param title [String] the title to be displayed
    private def title_ui(title)
        print_fill("=")
        puts_bordered_line(title, "center")
        print_fill("=")
    end

    # @param menu_manager [MenuManager] the menu to be displayed
    private def menu_ui(menu_manager)
        if menu_manager.current_menu.menu_banner != nil
            puts_bordered_line(menu_manager.current_menu.menu_banner, "center")
        end
        for menu in menu_manager.menu_list
            puts_bordered_line(menu, "left")
        end

        print_fill("=")
    end

    # @param inspecting [Creature] the creature that is being inspected
    private def inspecting_ui(inspecting)
        buffsDebuffs = inspecting.effects.effects.map{|effect| effect.display_name}.join(", ")

        print_fill("=")
        puts_bordered_line("#{inspecting.name}", "center")
        puts_bordered_line("", "left")
        puts_bordered_line("HP: #{inspecting.hp.hp_colorized}  MP: #{inspecting.mp.mp_colorized}", "left")
        puts_bordered_line("Atk: #{inspecting.atk.atk_colorized}  Matk: #{inspecting.matk.matk_colorized}", "left")
        puts_bordered_line("Natural HP Regen: #{inspecting.nmpr.natural_mp_regen_colorized}", "left")
        puts_bordered_line("Natural MP Regen: #{inspecting.nhpr.natural_hp_regen_colorized}", "left")
        puts_bordered_line("Acc: #{inspecting.acc.accuracy_colorized}  Dodge: #{inspecting.dodge.dodge_colorized}  Spd: #{inspecting.speed.speed_colorized}", "left")
        puts_bordered_line("Buffs/Debuffs: #{buffsDebuffs}", "left")
        print_fill("=")
    end

    # @param map [Map] the map to be displayed
    private def map_ui(map)
        player_pov = map.get_pov_symbols
        
        for y in 0...player_pov.length
            line = ""
            for x in 0...player_pov[0].length
                line += player_pov[y][x]
            end
            puts_bordered_line(line, "center")
        end
        print_fill("=")
    end

    # @param menu_element [MenuElement, nil] the menu to be displayed as tooltip
    private def tooltip_ui(menu_element)
        if menu_element != nil && menu_element.tooltip != nil
            # check if tooltip is too long to fit in one line, if so, split it into multiple lines
            tooltip = menu_element.tooltip
            if tooltip.length > @box_width - 4
                tooltip_lines = []
                while tooltip.length > @box_width - 4
                    tooltip_lines.push(tooltip[0...(@box_width - 4)])
                    tooltip = tooltip[(@box_width - 4)..-1]
                end
                tooltip_lines.push(tooltip)
                for line in tooltip_lines
                    puts_bordered_line(line, "left")
                end
            else
                puts_bordered_line(tooltip)
            end
        else
            puts_bordered_line("press up and down arrow key to select and Enter to confirm", "left")
        end

        print_fill("=")
    end

    # @param player [Creature] the player to be displayed
    # @param enemy [Creature] the enemy to be displayed
    private def player_enemy_ui(player, enemy)
        print_fill("=")
        prints_bordered_line("#{player.name_colorized}", "center", @box_width/2); 
        prints_bordered_line("#{enemy.name_colorized}", "center", @box_width/2); 
        printf("\n")
        prints_bordered_line("HP: #{player.hp.current_hp}/#{player.hp.max_hp}", "left", @box_width / 2); 
        prints_bordered_line("HP: #{enemy.hp.current_hp}/#{enemy.hp.max_hp}", "left", @box_width / 2);
        printf("\n")
        prints_bordered_line("MP: #{player.mp.current_mp}/#{player.mp.max_mp}", "left", @box_width / 2); 
        prints_bordered_line("MP: #{enemy.mp.current_mp}/#{enemy.mp.max_mp}", "left", @box_width / 2); 
        printf("\n")
        prints_bordered_line(apply_elipsis(player.effects.effects.map{|effect| effect.short_display_name}.join(", "), @box_width / 2 - 4), "left", @box_width / 2); 
        prints_bordered_line(apply_elipsis(enemy.effects.effects.map{|effect| effect.short_display_name}.join(", "), @box_width / 2 - 4), "left", @box_width / 2);
        printf("\n")
        print_fill("=")
    end

    # @param logs [Array<string>] the logs to be displayed
    # @param max_logs [Integer, nil] the maximum number of logs to be displayed, if nil, display all logs
    private def log_ui(logs, max_logs = nil)
        if max_logs != nil && logs.length > max_logs
            logs = logs[-max_logs..-1]
        end

        for log in logs
            puts_bordered_line(log, "left")
        end

        print_fill("=")
    end

    def print
        # top-border
        self.title_ui("CHREZ RPG")

        if @game.logs != nil
            self.log_ui(@game.logs)
        end

        unless @game.menu_manager.current_menu.nil?
            self.menu_ui(@game.menu_manager)
        end
        
        if (@game.player != nil) && (@game.enemy != nil)
            self.player_enemy_ui(@game.player, @game.enemy)
        end

        unless @game.inspecting.nil?
            self.inspecting_ui(@game.inspecting)
        end

        self.tooltip_ui(@game.menu_manager.current_selected)

    end
end