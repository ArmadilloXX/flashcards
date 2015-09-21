class MainController < ApplicationController

  def welcome
  end
  
  def index
    if params[:id]
      @card = current_user.cards.find(params[:id])
    else
      if current_user.current_block
        @card = current_user.current_block.cards.pending.first
        @card ||= current_user.current_block.cards.repeating.first
      else
        @card = current_user.cards.pending.first
        @card ||= current_user.cards.repeating.first
      end
    end
    
  end
end
