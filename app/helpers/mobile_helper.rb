# -*- encoding : utf-8 -*-
module MobileHelper

  def controller_selected?(controllers)
    #This is done because in _project_navigation.m.haml, the People and Contacts links would both have "people" controller.controller_name and "selected" would not work //GM
    if controllers == "contacts" || controllers == "people"
        'selected' if Array(controllers).include? controller.action_name
    else
        'selected' if Array(controllers).include? controller.controller_name
    end

  end

end
