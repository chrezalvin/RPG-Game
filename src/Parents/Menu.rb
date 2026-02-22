require_relative "./MenuElement"

class Menu
    attr_reader :selected_idx

    @@default_selected_idx = 0
    def initialize(menu_list = [])
        @selected_idx = @@default_selected_idx
        @menu_list = menu_list
    end

    def menu_list
        @menu_list.each_with_index.map{|menu, idx| idx == @selected_idx ? "> #{menu.menu_name}" : "  #{menu.menu_name}"}
    end

    def focus_next_element
        @selected_idx = (@selected_idx + 1) % (@menu_list.length)

        self.hover_current_element
    end

    def focus_prev_element
        @selected_idx = (@selected_idx - 1) % (@menu_list.length)

        self.hover_current_element
    end

    def select_current_element
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx].select_menu_element()
        end
    end

    def hover_current_element
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx].hover_menu_element()
        end
    end

    def current_selected
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx]
        else nil
        end
    end
end