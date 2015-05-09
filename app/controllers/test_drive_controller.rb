class TestDriveController < ApplicationController
	
	before_filter :authenticate_tcustomer,	:only => [:addshoes, :addshoe, :delshoe, :ask, :prediction, :solidify, :do_solidify]
	before_filter :save_tlogin_state,				:only => [:create]

  def start
  end

  def create
    @parms = newtcustomer_params
    @tcustomer = TempCustomer.new(@parms)
    @tcustomer.save!
    session[:temp] = true
    session[:tCustID] = @tcustomer.tCustID
    redirect_to td_addshoes_path
  end

  def addshoes
    @shoes = TempShoe.where({OwnerID: @tcustomer.tCustID}).to_a
  end

  def addshoe
    @parms = newshoe_params
    newShoe = @tcustomer.shoes.build(@parms)
    newPreSize = Shoe.sizeToPreSize(@parms[:Size], @parms[:SizeType], @parms[:LengthFit])
    if not @tcustomer.ShoeSize or (newPreSize - @tcustomer.ShoeSize).abs <= 30.0
      newShoe.save
      @tcustomer.updateStats
    else
      flash[:warning] = "You entered a new shoe with a size very different to your previous average shoe size. Please check the size of your new shoe or that of the shoes you have already entered."
    end

    redirect_to td_addshoes_path
  end

  def delshoe
    @parms = delshoe_params
    TempShoe.destroy(@parms[:ShoeID])
    @tcustomer.updateStats

    redirect_to td_addshoes_path
  end

  def ask
  end

  def prediction
    @parms = predic_params
    results = @tcustomer.predictSizeToBuy(@parms[:Brand], @parms[:Style], @parms[:Material], @parms[:SizeType])
    @parms["prediction"] = results[:prediction]
    @parms["error"] = results[:error]
    @parms["pref1"] = results[:pref1]
    @parms["pref2"] = results[:pref2]
  end

  def solidify
  end
  
  def do_solidify
    @parms = solidify_params
    if @parms[:Email] == @parms[:Email_confirmation]
      @customer = Customer.new(@parms.reject{|k,v| k == "Email_confirmation"})  # Customer model doesn't have Email_confirmation field
      @customer.save!
      @tcustomer.shoes.each do |s|
        @customer.shoes.create!(s.attributes.reject{|k,v| k == "ShoeID" or k == "created_at" or k == "updated_at"})
      end

      session[:temp] = false
      session[:tCustID] = nil
      @tcustomer.destroy
      @tcustomer = nil
      session[:CustID] = @customer.CustID
      redirect_to home_path
    else
      flash[:warning] = "Your email address was not entered correctly."
      redirect_to td_solidify_path, method: :get
    end
  end

  private
    def newtcustomer_params
      params.require(:td_start).permit(:Gender)
    end

    def newshoe_params
      params.require(:td_newshoe).permit(:OwnerID, :Brand, :Style, :Material, :Size, :SizeType, :LengthFit)
    end

    def delshoe_params
      params.require(:td_delshoe).permit(:ShoeID)
    end

    def predic_params
      params.require(:predic).permit(:Brand, :Style, :Material, :SizeType)
    end

    def solidify_params
      params.require(:td_solidify).permit(:Email, :Email_confirmation, :Gender, :password, :password_confirmation)
    end
end
