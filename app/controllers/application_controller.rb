class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_customer
  	if session[:CustID]
  		@customer = Customer.find_by_CustID!(session[:CustID])
  		return true
  	else
  		redirect_to signin_path
  		return false
  	end
  end

  def save_login_state
  	if session[:CustID]
      @customer = Customer.find_by_CustID(session[:CustID])
      if @customer
        redirect_to home_path
        return false
      else
        session[:CustID] = nil
        return true
      end
  	else
  		return true
  	end
  end
end
