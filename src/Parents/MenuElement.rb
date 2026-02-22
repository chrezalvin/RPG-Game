class MenuElement
    attr_reader :menu_name, :tooltip
    def initialize(menu_name, on_selected, tooltip = nil, on_hover = nil)
        @menu_name = menu_name
        @on_selected = on_selected
        @on_hover = on_hover
        @tooltip = tooltip
    end

    def select_menu_element
        # check if menu element is callable first
        if @on_selected.respond_to?("call")
            @on_selected.call
        end
    end

    def hover_menu_element
        if @on_hover.respond_to?("call")
            @on_hover.call
        end
    end
end