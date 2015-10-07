class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.add_role params[:user][:roles]
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
      @user = User.find(params[:id])
      params[:user].delete(:password) if params[:user][:password].blank?
      params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
      if @user.update_attributes(user_params)
        @user.roles.clear
        @user.add_role params[:user][:roles]
        flash[:notice] = "Successfully updated User."
        redirect_to admin_users_path
      else
        render :action => 'edit'
      end
    end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to admin_users_path
    end
  end

  def user_params
  	if can? :manage, User
  		params.require(:user).permit(:email, :password, :password_confirmation)
  	end
  end

end
