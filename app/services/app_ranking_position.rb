class AppRankingPosition < Base

  attr_accessor  :rank_position

  validates      :rank_position, numericality: {  only_integer:             true,
                                                  greater_than_or_equal_to: 1   ,
                                                  less_than_or_equal_to:    200  }

  def perform_request
    execute_api_calls_and_evalute_responses
  end

  private

    def top_charts_for_monetization_type 
      apple_store_response.top_charts_for_monetization.fetch(element_array_position)
    end

    def element_array_position
      self.rank_position.to_i - 1
    end

    def get_app_metadata
      @apple_lookup_result ||= Client::AppleLookupApi.new( [top_charts_for_monetization_type] ).get_apps_metadata
    end

    def execute_api_calls_and_evalute_responses
      apple_store_response.valid? ? evaluate_apple_lookup_api_call : apple_store_response.error
    end

    def apple_store_response
      @apple_store_response ||= Response::AppleStoreResponse.new(get_top_apps_from_apple_store, self.monetization)
    end

    def get_top_apps_from_apple_store
      @apple_store_result   ||= Client::AppleStoreApi.new(self.category_id, self.monetization).get_top_apps
    end

    def evaluate_apple_lookup_api_call
      apple_lookup_response.valid? ? apple_lookup_response.build_top_apps_response : apple_lookup_response.error
    end

    def apple_lookup_response
      @apple_lookup_response ||= Response::AppleLookupResponse.new( get_app_metadata )
    end

end