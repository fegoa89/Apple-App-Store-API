class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def accepted_params
      params.permit(:category_id, :monetization, :rank_position)
    end
end
