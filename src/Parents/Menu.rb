require "forwardable"

require "Parents/MenuElement"
require "utils/Event"

class Menu extend Forwardable
    attr_reader :selected_idx,
        :on_focus_next_element, 
        :on_focus_prev_element, 
        :on_select_current_element, 
        :on_select_right_current_element, 
        :on_select_left_current_element, 
        :on_hover_current_element

    def_delegator :@on_focus_next_element, :subscribe, :on_focus_next_element
    def_delegator :@on_focus_prev_element, :subscribe, :on_focus_prev_element
    def_delegator :@on_select_current_element, :subscribe, :on_select_current_element
    def_delegator :@on_select_right_current_element, :subscribe, :on_select_right_current_element
    def_delegator :@on_select_left_current_element, :subscribe, :on_select_left_current_element
    def_delegator :@on_hover_current_element, :subscribe, :on_hover_current_element

    @@default_selected_idx = 0
    def initialize(menu_list = [])
        @selected_idx = @@default_selected_idx
        @menu_list = menu_list


        @on_focus_next_element = Event.new
        @on_focus_prev_element = Event.new
        @on_select_current_element = Event.new
        @on_select_right_current_element = Event.new
        @on_select_left_current_element = Event.new
        @on_hover_current_element = Event.new
    end

    def menu_list
        @menu_list.each_with_index.map{|menu, idx| idx == @selected_idx ? "> #{menu.menu_name}" : "  #{menu.menu_name}"}
    end

    def focus_next_element
        @selected_idx = (@selected_idx + 1) % (@menu_list.length)
        @on_focus_next_element.emit

        self.hover_current_element
    end

    def focus_prev_element
        @selected_idx = (@selected_idx - 1) % (@menu_list.length)
        @on_focus_prev_element.emit

        self.hover_current_element
    end

    def select_current_element
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx].select_menu_element()
            @on_select_current_element.emit
        end
    end

    def hover_current_element
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx].hover_menu_element()
            @on_hover_current_element.emit
        end
    end

    def select_right_current_element
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx].select_right_menu_element()
            @on_select_right_current_element.emit
        end
    end

    def select_left_current_element
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx].select_left_menu_element()
            @on_select_left_current_element.emit
        end
    end

    def current_selected
        if @menu_list[@selected_idx].is_a? MenuElement
            @menu_list[@selected_idx]
        else nil
        end
    end
end