class SessionController < ApplicationController

	layout 'in_session', only: :index

  # Only specified methods skip authorized callback
  skip_before_action :authorized, only: [ :new, :create, :welcome]

  def index
  end

  def new
  end

  def create
    @user = User.find_by(name: params[ :name])
    if @user && CRYPT.decrypt_and_verify(@user.password) == params[ :password]
      session[ :user_id] = @user.id
      redirect_to '/index'
    else
      flash[ :alert] = 'Alguno de los credenciales no es correcto. Vuelva a intentarlo, por favor.'
      redirect_to '/welcome'
    end
  end

  def welcome
    if session[ :user_id] != nil
      session[ :user_id] = nil
    end
  end

end
