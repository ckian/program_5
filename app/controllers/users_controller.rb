class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show, :edit, :update]
  #before_filter :correct_user, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_for_users, :only => [:new, :create]

  def index
    @users = User.search(params[:search])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.email
    @user.assets.build
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create  
      @user = User.create( params[:user] )
    if @user.save
      sign_in @user
      flash[:success] = "Welcome Image Nation #{@user.first_name}!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  private
  
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
