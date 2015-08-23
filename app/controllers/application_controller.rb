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
        error_message:  detailed_errors(messages)
      }
    end

    def detailed_errors(errors)
      error_string = ""
      errors.each do |k, v|
        error_string << "Parameter #{k} #{v.first} ."
      end
      error_string
    end

    def accepted_params
      params.permit(:category_id, :monetization, :rank_position)
    end

end
