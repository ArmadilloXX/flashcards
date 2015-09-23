class Dashboard::TrainerController < Dashboard::BaseController

  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      set_card_for_review
    end
  end

  def review_card
    @card = current_user.cards.find(params[:card_id])
    check_result = @card.check_translation(trainer_params[:user_translation])
    if check_result[:state]
      prepare_flash_message(check_result[:distance])
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: @card.id)
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end

  def set_card_for_review
    if current_user.current_block
      set_card_from_current_block
    else
      set_card
    end
  end

  def set_card_from_current_block
    @card = current_user.current_block.cards.pending.first ||
      current_user.current_block.cards.repeating.first
  end

  def set_card
    @card = current_user.cards.pending.first ||
      current_user.cards.repeating.first
  end

  def prepare_flash_message(distance)
    if distance == 0
      flash[:notice] = t(:correct_translation_notice)
    else
      flash[:alert] = t 'translation_from_misprint_alert',
                        user_translation: trainer_params[:user_translation],
                        original_text: @card.original_text,
                        translated_text: @card.translated_text
    end
  end
end
