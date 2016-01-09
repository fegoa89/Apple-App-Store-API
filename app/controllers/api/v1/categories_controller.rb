module Api
  module V1
    class CategoriesController < ApplicationController

      def top_apps
        @result ||= top_apps_request.valid? ? top_apps_request.perform_request : render_error(top_apps_request.errors.messages)
      end

      def app_by_ranking_position
        @result ||= app_ranking_position.valid? ? app_ranking_position.perform_request : render_error(app_ranking_position.errors.messages)
      end

      def publishers_ranking
        @result ||= publishers_ranking_request.valid? ? publishers_ranking_request.perform_request : render_error(publishers_ranking_request.errors.messages)
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