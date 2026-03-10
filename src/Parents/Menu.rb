require "forwardable"

require "Parents/MenuElement"
require "utils/Event"

class Menu
    attr_reader :menu_list, :menu_title, :menu_banner

    # Initialize a menu with the given menu list
    # @param menu_list [Array<MenuElement>] The list of menu elements to be displayed in the menu
    def initialize(menu_list = [])
        @menu_title = "Unknown Menu"
        @menu_list = menu_list
        @menu_banner = nil
    end
end