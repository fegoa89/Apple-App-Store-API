module Api
  module V1
    class CategoriesController < ApplicationController

      def top_apps
        if top_apps_request.valid?
          @result = top_apps_request.perform_request
        else
          render_error(top_apps_request.errors.messages)
        end
      end

      def publishers_ranking

      end

      def app_by_ranking_position

      end

      private

        def top_apps_request
          @app ||= TopAppsRequest.new(accepted_params)
        end

    end
  end
end