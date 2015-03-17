class SessionsController < ApplicationController
  
  before_filter :save_login_state, :only => [:signin, :signin_attempt]

  def signin
  end

  def signin_attempt
  	@parms = params[:signin]
  	@customer = Customer.find_by_Email(@parms["Email"])
  	if not @customer
      flash[:warning] = "Email address not found. Please try again."
      redirect_to signin_path
  	elsif @customer.authenticate(@parms["password"])
  		session[:CustID] = @customer.CustID
  		redirect_to home_path
  	else
      flash[:warning] = "Incorrect email/password combination"
  		redirect_to signin_path
  	end
  end

  def signout
  	session[:CustID] = nil
  	redirect_to signin_path
  end
end
