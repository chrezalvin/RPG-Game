class MenuElement
    attr_reader :menu_name, :tooltip
    def initialize(menu_name, on_selected, tooltip = nil)
        @menu_name = menu_name
        @on_selected = on_selected
        @tooltip = tooltip
    end

    def select_menu_element
        # check if menu element is callable first
        if @on_selected.respond_to?("call")
            @on_selected.call
        end
    end
end