require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :set_locale

  private

  def set_locale
    puts "\nSTART OF SETTING"
    locale = if current_user
                puts 'current_user'
                puts current_user.locale
                current_user.locale
              elsif params[:user_locale]
                puts 'user_locale'
                puts params[:user_locale]
                params[:user_locale]
              elsif session[:locale]
                puts 'session'
                puts session[:locale]
                session[:locale]
              else
                puts "After accept_language"
                http_accept_language.compatible_language_from(I18n.available_locales)
              end
    puts "END OF SETTING\n"
    puts "Assigned locale: #{locale.inspect}\n"

    if locale && I18n.available_locales.include?(locale.to_sym)
      puts "setting user locale\n"
      session[:locale] = I18n.locale = locale
    else
      puts "setting the default locale\n"
      session[:locale] = I18n.locale = I18n.default_locale
    end
  end

  # def set_session_locale(locale)
  #   if locale && I18n.available_locales.include?(locale.to_sym)
  #     puts "setting user locale\n"
  #     session[:locale] = I18n.locale = locale
  #   else
  #     puts "setting the default locale\n"
  #     session[:locale] = I18n.locale = I18n.default_locale
  #   end
  # end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
