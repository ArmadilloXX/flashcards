class Dashboard::TrainerController < Dashboard::BaseController

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      @card = current_user.cards_for_review.first
    end
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])
    check_result = @card.check_translation(trainer_params[:user_translation])
    if check_result[:state]
      prepare_flash_message(check_result[:distance])
      redirect_to trainer_path
    else
      ahoy.track("Card reviewed", result: "Failure")
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end

  def prepare_flash_message(distance)
    if distance == 0
      ahoy.track("Card reviewed", result: "Success")
      flash[:notice] = t(:correct_translation_notice)
    else
      ahoy.track("Card reviewed", result: "Typo/Missprint")
      flash[:alert] = t "translation_from_misprint_alert",
                        user_translation: trainer_params[:user_translation],
                        original_text: @card.original_text,
                        translated_text: @card.translated_text
    end
  end
end
