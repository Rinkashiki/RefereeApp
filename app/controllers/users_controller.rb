class UsersController < ApplicationController

  # Render navigation bar
  layout 'in_session', only: [ :index, :edit]

  # Permit access to login and sign up
  skip_before_action :authorized, only: [ :new, :create]

  # Extract the current user before any method is executed
  before_action :set_user, only: [ :edit, :update, :show, :destroy]


  #protect_from_forgery :except => [ :new ]

  def index
    @users = User.all
  end

  # New user sign up by himself/herself. The assign profile is the default one (User)
  def new
    @user = User.new
    @profiles = Profile.all
  end

  def create

    # Default profile when signing up is 'User'. When another user signs you up, he/she can choose user's new profile
    if !params[ :user][ :profile].nil?
      @profile = Profile.find_by_name(params[ :user][ :profile])
    else
      @profile = Profile.find_by_name('Usuario')
    end
    @user = @profile.users.new user_params
    password = SecureRandom.alphanumeric
    @user[ :password] = CRYPT.encrypt_and_sign(password)
    
    respond_to do |format|
      if @user.save
        # Send an email to new registered user with him/her credentials
        UserMailer.with(user: @user, password: password).new_user_email.deliver_later
        @notification = 'Succesfully registered!'
      else
        @notification = @user.errors.first.full_message
      end

      format.js
    end

  end

  def show
  end

  def edit
    @profiles = Profile.all
  end

  def update
    @profile = Profile.find_by_name(params[ :user][ :profile])

    @user[ :profile_id] = @profile[ :id]
    @user.update user_params

    flash[ :alert] = 'Succesfully edited!'

    redirect_to users_path
  end

  def destroy
    @user.destroy
    flash[ :alert] = 'Successfully deleted user'
    redirect_to users_path
  end


  private

  def user_params
    params.require( :user).permit( :name, :surname, :email)    
  end

  def set_user
    @user = User.find params[ :id]
  end

end
