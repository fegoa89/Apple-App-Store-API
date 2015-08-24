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

      def app_by_ranking_position
        if app_ranking_position.valid?
          @result = app_ranking_position.perform_request
        else
          render_error(app_ranking_position.errors.messages)
        end
      end


      def publishers_ranking
        if publishers_ranking_request.valid?
          @result = publishers_ranking_request.perform_request
        else
          render_error(publishers_ranking_request.errors.messages)
        end
      end

      private

        def top_apps_request
          @top_apps ||= TopAppsRequest.new(accepted_params)
        end

        def app_ranking_position
          @app_ranking ||= AppRankingPosition.new(accepted_params)
        end

        def publishers_ranking_request
          @pub_ranking ||= PublishersRanking.new(accepted_params)
        end

    end
  end
end