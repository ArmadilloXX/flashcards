class Dashboard::BatchesController < Dashboard::BaseController
  def new
  end

  def create
    params[:batch][:user_id] = current_user.id
    AddCardsFromUrlJob.perform_later batch_params
    redirect_to cards_path,
                notice: "Cards adding task from "\
                "#{batch_params[:url]} was created"
  end

  private

  def batch_params
    params.require(:batch).permit(:url,
                                  :original_selector,
                                  :translated_selector,
                                  :block_id,
                                  :user_id)
  end
end
