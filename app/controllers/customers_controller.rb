class CustomersController < ApplicationController
	
	before_filter :authenticate_customer,	:only => [:home, :addshoe, :delshoe, :predict]
	before_filter :save_login_state,			:only => [:new, :create]

	def new
	end

	def create
		@parms = newcustomer_params
		if @parms["Email"] == @parms["Email_confirmation"]
			@customer = Customer.new(@parms.reject{|k,v| k == "Email_confirmation"})	# Customer model doesn't have Email_confirmation field -- only used here for verification.
			@customer.save!
			session[:CustID] = @customer.CustID
			# session[:preferredSizeType] = Sizetype.find_by_SizeType!(@customer.preferredSizeType)
			redirect_to home_path
		else
			flash[:warning] = "Your email address was not entered correctly."
			redirect_to signup_path
		end
	end

	def home
		@shoes = @customer.shoes.to_a
		@newshoe = @customer.shoes.build(SizeType: @customer.preferredSizeType)
	end

	def index
		@customers = Customer.all
	end

	def addshoe
		@parms = newshoe_params
		newShoe = @customer.shoes.build(@parms)
		newPreSize = Shoe.sizeToPreSize(@parms[:Size], @parms[:SizeType], @parms[:LengthFit])
		if not @customer.ShoeSize or (newPreSize - @customer.ShoeSize).abs <= 30.0
			newShoe.save
			# @customer.updateStats -- commented because of updateStats call in Shoe.rb's after_save trigger
		else
			flash[:warning] = "You entered a new shoe with a size very different to your previous average shoe size. Please check the size of your new shoe or that of the shoes you have already entered."
		end

		redirect_to home_path
	end

	def delshoe
		@parms = delshoe_params
		Shoe.destroy(@parms[:ShoeID])
		# Customer.updateStats(@customer.CustID)
		@customer.updateStats

		redirect_to home_path
	end

	def predict
		@parms = predic_params
		# Customer.establish_connection
		results = @customer.predictSizeToBuy(@parms[:Brand], @parms[:Style], @parms[:Material], @parms[:SizeType])
		@parms["prediction"] = results[:prediction]
		@parms["error"] = results[:error]
		@parms["pref1"] = results[:pref1]
		@parms["pref2"] = results[:pref2]
	end

	private
		def newcustomer_params
			params.require(:customer).permit(:Email, :Email_confirmation, :Gender, :password, :password_confirmation, :preferredSizeType)
		end

		def newshoe_params
			params.require(:newshoe).permit(:OwnerID, :Brand, :Style, :Material, :Size, :SizeType, :LengthFit)
		end

		def delshoe_params
			params.require(:delshoe).permit(:ShoeID)
		end

		def predic_params
			params.require(:predic).permit(:Brand, :Style, :Material, :SizeType)
		end
end