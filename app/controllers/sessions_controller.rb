class SessionsController < ApplicationController
  
before_filter :authenticate_for_users, :only => [:new, :create]
#before_filter :authenticate,           :only => [:destroy]

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    #if user.nil?
    #  redirect_
      sign_out
      redirect_to root_path
  end
end