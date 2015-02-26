module ApplicationHelper

	def bootstrap_class_for flash_type
		#{success: "alert-success", info: "alert-info",	warning: "alert-warning",	danger: "alert-danger"}[flash_type] || flash_type.to_s
		"alert-".concat(flash_type.to_s)
	end

	def flash_messages(opts={})
		flash.each do |flash_type, message|
			concat(
				content_tag(:div, class: "alert #{bootstrap_class_for flash_type}") do
					concat content_tag(:button, "&times;".html_safe, class: "close", type: "button", data: {dismiss: "alert"})
					concat message
				end
			)
		end
		nil
	end

	def T2RS_initialise
		Brand.pluck(:Brand).each do |brand|
			Style.pluck(:Style).each do |style|
				Material.pluck(:Material).each do |material|
					Typetorealsize.new(BrandStyleMaterial: brand +"|"+ style +"|"+ material).save!
				end
			end
		end
	end
end