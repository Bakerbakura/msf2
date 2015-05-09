class CustomersController < ApplicationController
	
	before_filter :authenticate_customer,	:only => [:home, :addshoe, :delshoe, :predict]
	before_filter :save_login_state,			:only => [:welcome, :new, :create, :signin, :signin_attempt]
  
  def welcome
  end

  def start
  end

  def addshoes
  	@parms = addshoes_params
  	# shoes = @parms.map{|h| Shoe.new(h)}
  	# preSizes = shoes.map{|s| Shoe.sizeToPreSize(s.Size, s.SizeType, s.LengthFit)}
  	preSizes = @parms.map{|h| Shoe.sizeToPreSize(h["Size"], h["SizeType"], h["LengthFit"])}
  	preSizeMean = preSizes.sum/preSizes.count
  	if preSizes.map{|p| (preSizeMean - p).abs <= 30.0}.all?
  		session[:shoeHashes] = @parms.map.with_index{|h,i| [i,h]}.to_h
  		redirect_to userinfo_path
  	else
  		flash[:warning] = "The shoes you entered have very different sizes. Please check the details of the shoes you have entered."
  		redirect_to start_path
  	end
  end

  def getinfo
  end

  def consolidate
  	@parms = newuser_params
  	if @parms["Email"] == @parms["Email_confirmation"]
  		@customer = Customer.create!(@parms.reject{|k,v| k == "Email_confirmation"})	# what if customer has non-matching passwords?
  		session[:shoeHashes].each_value{|h| @customer.shoes.create!(h)}
  		session[:shoeHashes] = nil
  		session[:CustID] = @customer.CustID
  		session[:activeTime] = Time.now.ctime
  		redirect_to home_path
  	else
  		flash[:warning] = "Your email address was not entered correctly."
  		redirect_to userinfo_path
  	end
  end

  def new
  end

	def create
		@parms = newuser_params
		if @parms["Email"] == @parms["Email_confirmation"]
			@customer = Customer.create!(@parms.reject{|k,v| k == "Email_confirmation"})	# what if customer has non-matching passwords?
			session[:CustID] = @customer.CustID
			session[:activeTime] = Time.now.ctime
			redirect_to home_path
		else
			flash[:warning] = "Your email address was not entered correctly."
			redirect_to signup_path
		end
	end

	def signin
	end

  def signin_attempt
  	@parms = signin_params
  	@customer = Customer.find_by_Email(@parms["Email"])
  	if not @customer
      flash[:warning] = "Email address not found. Please try again."
      redirect_to signin_path
  	elsif @customer.authenticate(@parms["password"])
  		session[:CustID] = @customer.CustID
      session[:activeTime] = Time.now.ctime
  		redirect_to home_path
  	else
      flash[:warning] = "Incorrect email/password combination"
  		redirect_to signin_path
  	end
  end

  def home
  	@shoes = @customer.shoes.to_a
  end

	def index
		@customers = Customer.all
	end

	def addshoe
		parms = newshoe_params
		newShoe = @customer.shoes.build(parms)
		newPreSize = Shoe.sizeToPreSize(parms[:Size], parms[:SizeType], parms[:LengthFit])
		if not @customer.ShoeSize or (newPreSize - @customer.ShoeSize).abs <= 30.0
			newShoe.save
			# @customer.updateStats -- commented because of updateStats call in Shoe.rb's after_save trigger
		else
			flash[:warning] = "You entered a new shoe with a size very different to your previous average shoe size. Please check the size of your new shoe or that of the shoes you have already entered."
		end

		redirect_to home_path
	end

	def delshoe
		parms = delshoe_params
		Shoe.destroy(parms[:ShoeID])
		@customer.updateStats

		redirect_to home_path
	end

	def predict
		spec = predic_params
		flash[:results] = @customer.predictSizeToBuy(spec[:Brand], spec[:Style], spec[:Material])
		flash[:spec] = spec
		redirect_to predict_path
	end

	def prediction
		@spec = flash[:spec]
		@results = flash[:results]
		puts(@results)
	end

	def signout
		session[:CustID] = nil
		session[:activeTime] = nil
		redirect_to signin_path
	end

	private
		def addshoes_params
			result = []
			result << params.require(:shoe1).permit(:Brand, :Style, :Material, :SwT, :LengthFit)
			result << params.require(:shoe2).permit(:Brand, :Style, :Material, :SwT, :LengthFit)
			result << params.require(:shoe3).permit(:Brand, :Style, :Material, :SwT, :LengthFit)
			return result.map{|h| SwT_split(h)}
		end

		def newuser_params
			params.require(:newuser).permit(:Email, :Email_confirmation, :Gender, :password, :password_confirmation)
		end

		def signin_params
			params.require(:signin).permit(:Email, :password)
		end

		def newshoe_params
			SwT_split(params.require(:newshoe).permit(:OwnerID, :Brand, :Style, :Material, :SwT, :LengthFit))
		end

		def delshoe_params
			params.require(:delshoe).permit(:ShoeID)
		end

		def predic_params
			params.require(:predic).permit(:Brand, :Style, :Material)
		end

		def SwT_split(_h)
			st = _h["SwT"].split('|')
			return _h.reject{|k,v| k == "SwT"}.merge({Size: st[0].to_f, SizeType: st[1]})
		end
end