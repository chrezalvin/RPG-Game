require "utils/Event"

class MenuElement
    attr_reader :menu_name, :tooltip

    # Initialize a menu element with the given parameters
    # @param menu_name [String] The name of the menu element to be displayed
    # @param tooltip [String, nil] The tooltip text to be displayed when hovering over
    # @param on_hover [Proc, nil] The callback to be executed when the menu element is hovered
    # @param on_selected [Proc, nil] The callback to be executed when the menu element is selected
    # @param on_select_right [Proc, nil] The callback to be executed when the right arrow key is pressed while the menu element is selected
    # @param on_select_left [Proc, nil] The callback to be executed when the left arrow key is pressed while the menu element is selected
    def initialize(
            menu_name: "Unknown Menu Element", 
            tooltip: nil, 
            on_hover: nil,
            on_selected: nil,
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
        return false unless @on_selected&.respond_to?("call")
        
        @on_selected.call

        return true
    end

    def hover_menu_element
        return false unless @on_hover&.respond_to?("call")

        @on_hover.call

        return true
    end

    def select_right_menu_element
        return false unless @on_select_right&.respond_to?("call")

        @on_select_right.call
        
        return true
    end

    def select_left_menu_element
        return false unless @on_select_left&.respond_to?("call")
        
        @on_select_left.call

        return true
    end
end