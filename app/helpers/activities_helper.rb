module ActivitiesHelper

	def get_tab tab, current_tab
		p "*****#{tab}*****#{current_tab}------"
		if tab.to_i == current_tab.to_i
			return "active"
		else
			return ""
		end
	end
	def get_pane tab, current_tab
		p "*****#{tab}*****#{current_tab}-------"
		if tab.to_i == current_tab.to_i
			return "active in"
		else
			return ""
		end
	end
end
