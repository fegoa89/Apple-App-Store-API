class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    def render_error(error_messages)
      render json: json_error(error_messages), status: :bad_request
    end

    def json_error(messages)
      {
        error:          400,
        requested_path: "#{self.action_name}",
        message:        "Params #{messages.keys.join(", ")} must be present"
      }
    end

    def accepted_params
      params.permit(:category_id, :monetization, :rank_position)
    end

end
