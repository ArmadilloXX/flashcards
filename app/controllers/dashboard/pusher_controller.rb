module Dashboard 
  class PusherController < Dashboard::BaseController
    protect_from_forgery :except => :auth 

    def auth
      if current_user
        response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
        render json: response
      else
        render text: "Not authorized", status: "403"
      end
    end
  end
end
