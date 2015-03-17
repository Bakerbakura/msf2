class WelcomeController < ApplicationController
  def index
  	session[:temp] = false
  	session[:tCustID] = nil
  end
end
