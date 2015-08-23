module Response
  class AppleLookupResponse

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def valid?
      response.class == RestClient::BadRequest ? false : true
    end

    def build_top_apps_response
      json_response_with_results_metadata
    end

    def error
      { error: response.http_code, message: JSON.parse(response.http_body)["errorMessage"] }
    end


    private

      def json_response_with_results_metadata
        json_response = []

        formatted_response["results"].each do |result|
          json_response << { apple_store_id: result["trackId"] , metadata: add_single_response(result) }
        end

        json_response
      end

      def add_single_response(result)
        {
          price:               result["price"],
          app_name:            result["trackName"],
          description:         result["description"],
          version_number:      result["version"],
          publisher_name:      result["artistName"],
          small_icon_url:      result["artworkUrl60"],
          average_user_rating: result["averageUserRating"]
        }
      end

      def formatted_response
        @json_response = JSON.parse(response)
      end
  end
end