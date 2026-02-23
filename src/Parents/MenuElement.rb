class MenuElement
    attr_reader :menu_name, :tooltip
    def initialize(
            menu_name: "Unknown Menu", 
            on_selected: nil, 
            tooltip: nil, 
            on_hover: nil,
            on_select_right: nil,
            on_select_left: nil
        )

        @menu_name = menu_name
        @on_selected = on_selected
        @on_hover = on_hover
        @on_select_right = on_select_right
        @on_select_left = on_select_left
        @tooltip = tooltip
    end

    def select_menu_element
        # check if menu element is callable first
        @on_selected&.respond_to?("call") && @on_selected.call
    end

    def hover_menu_element
        @on_hover&.respond_to?("call") && @on_hover.call
    end

    def select_right_menu_element
        @on_select_right&.respond_to?("call") && @on_select_right.call
    end

    def select_left_menu_element
        @on_select_left&.respond_to?("call") && @on_select_left.call
    end
end