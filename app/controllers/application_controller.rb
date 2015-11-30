require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit
  self.responder = ApplicationResponder
  respond_to :html
  layout :choose_layout
  protect_from_forgery with: :exception
  before_action :set_locale

  def authenticate_admin_user!
    redirect_to login_path unless current_user
  end

  def access_denied(exception)
    redirect_back_or_to root_path, alert: exception.message
  end

  private

  def choose_layout
    current_user ? "dashboard" : "application"
  end

  def set_locale
    locale = if current_user
               current_user.locale
             elsif params[:user_locale]
               params[:user_locale]
             elsif session[:locale]
               session[:locale]
             else
               http_accept_language.compatible_language_from(
                 I18n.available_locales)
             end
    set_session_locale(locale)
  end

  def set_session_locale(locale)
    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale
    else
      session[:locale] = I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
