class CustomersController < ApplicationController
	
	before_filter :authenticate_customer,	:only => [:home, :addshoe, :delshoe, :predict]
	before_filter :save_login_state,			:only => [:new, :create]

	def new
	end

	def create
		@parms = newcustomer_params
		@lessparms = @parms.reject{|k,v| k == "Email_confirmation"}
		# puts @lessparms
		if @parms["Email"] == @parms["Email_confirmation"]
			@customer = Customer.new(@lessparms)
			@customer.save!
			session[:CustID] = @customer.CustID
			session[:preferredSizeType] = Sizetype.find_by_SizeType!(@customer.preferredSizeType)
			redirect_to home_path
		else
			flash[:warning] = "Your email address was not entered correctly."
			redirect_to signup_path
		end
	end

	def home
		@shoes = Shoe.where({OwnerID: @customer.CustID}).to_a
	end

	def index
		@customers = Customer.all
	end

	def addshoe
		@parms = newshoe_params
		newShoe = @customer.shoes.build(@parms)
		newPreSize = Shoe.sizeToPreSize(@parms[:Size], @parms[:SizeType], @parms[:LengthFit])
		if (newPreSize - @customer.ShoeSize).abs <= 30.0 or not @customer.ShoeSize
			newShoe.save
			Customer.updateShoeStats(@customer.CustID)
		else
			flash[:warning] = "You entered a new shoe with a size very different to your previous average shoe size. Please check the size of your new shoe or that of the shoes you have already entered."
		end

		redirect_to home_path
	end

	def delshoe
		@parms = delshoe_params
		Shoe.destroy(@parms[:ShoeID])
		Customer.updateShoeStats(@customer.CustID)

		redirect_to home_path
	end

	def predict
		@parms = predic_params
		Customer.establish_connection
		results = Customer.predictSizeToBuy(@parms[:CustID], @parms[:Brand], @parms[:Style], @parms[:Material], @parms[:SizeType])
		@parms["prediction"] = results[:prediction]
		@parms["error"] = results[:error]
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
			params.require(:predic).permit(:CustID, :Brand, :Style, :Material, :SizeType)
		end
end