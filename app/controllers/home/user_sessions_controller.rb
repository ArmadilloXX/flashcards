class Home::UserSessionsController < Home::BaseController
  def new
    if current_user
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    if @user = login(params[:email], params[:password])
      ahoy.authenticate(@user)
      ahoy.track("Login successful", method: "internal")
      redirect_back_or_to root_path, notice: t(:log_in_is_successful_notice)
    else
      ahoy.track("Login failure", method: "internal")
      flash.now[:alert] = t(:not_logged_in_alert)
      render action: "new"
    end
  end
end
