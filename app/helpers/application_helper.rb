module ApplicationHelper

	def bootstrap_class_for flash_type 	# assumes that flash_type is already one of :success, :info, :warning or :danger
		"alert-".concat(flash_type.to_s)
	end

	def flash_messages(opts={})
		flash.each do |flash_type, message|
			if [:success, :info, :warning, :danger].include?(flash_type)
				concat(
					content_tag(:div, class: "alert #{bootstrap_class_for flash_type} alert-dismissible", role: "alert") do
						concat (content_tag(:button, class: "close", type: "button", data: {dismiss: "alert"}, aria: {label: "Close"}) do
							concat content_tag(:span, "&times;".html_safe, aria: {hidden: "true"})
						end)
						concat message
					end
				)
			end
		end
		nil
	end
end