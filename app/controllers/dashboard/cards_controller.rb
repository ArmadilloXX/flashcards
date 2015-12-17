class Dashboard::CardsController < Dashboard::BaseController
  before_action :set_card, only: [:destroy, :edit, :update]

  def index
    @cards = current_user.cards.all.order("review_date")
    ahoy.track "Cards index opened"
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      track_flick_photo unless card_params[:remote_image_url].blank?
      ahoy.track "Card added", method: "individual", result: "success"
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def update
    if @card.update(card_params)
      track_flick_photo unless card_params[:remote_image_url].blank?
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def destroy
    @card.destroy
    ahoy.track "Card deleted"
    respond_with @card
  end

  private

  def track_flick_photo
    ahoy.track "Add Flickr photo"
  end

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date,
                                 :image, :image_cache, :remove_image,
                                 :remote_image_url, :block_id)
  end
end
