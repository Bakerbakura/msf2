class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_customer
    if session[:CustID] and session[:activeTime]
      @customer = Customer.find_by_CustID(session[:CustID])
      if @customer and Time.parse(session[:activeTime]) >= Time.now - 30 * 60  # if last recorded activity time is less than 30 minutes ago
        session[:activeTime] = Time.now.ctime
        return true
      else
        session[:CustID] = nil
        session[:activeTime] = nil
        redirect_to signin_path
        return false
      end
    else
  		session[:CustID] = nil
      session[:activeTime] = nil
      redirect_to signin_path
  		return false
    end
  end

  def save_login_state
    if session[:CustID] and session[:activeTime]
      @customer = Customer.find_by_CustID(session[:CustID])
      if @customer and Time.parse(session[:activeTime]) >= Time.now - 30 * 60 # if customer exists and last active time was after 30 minutes ago
        session[:activeTime] = Time.now.ctime
        redirect_to home_path
        return false
      else
        session[:CustID] = nil
        session[:activeTime] = nil
        return true
      end
  	else
      session[:CustID] = nil
      session[:activeTime] = nil
  		return true
    end
  end

  def authenticate_tcustomer
    if session[:temp] and session[:tCustID]
      @tcustomer = TempCustomer.find_by_tCustID!(session[:tCustID])
      return true
    else
      redirect_to welcome_path
      return false
    end
  end

  def save_tlogin_state
    if session[:temp] and session[:tCustID]
      @tcustomer = TempCustomer.find_by_tCustID(session[:tCustID])
      if @tcustomer
        redirect_to td_start_path
        return false
      else
        session[:tCustID] = nil
        return true
      end
    else
      return true
    end
  end
end
