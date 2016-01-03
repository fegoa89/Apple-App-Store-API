class Base
  # This class is sharing the performing request funtionality
  # with AppRankingPosition, TopAppsRequest and PublisherRanking class

  include                   ActiveModel::Model

  attr_accessor             :category_id,
                            :monetization,
                            :apple_store_result,
                            :apple_lookup_result

  validates_presence_of     :category_id,
                            :monetization

  validates :monetization,  inclusion:    { in:      %w(paid free grossing),
                                            message: "%{value} is not a valid monetization type" }

  validates :category_id ,  numericality: { only_integer: true }

  def perform_request
    execute_api_calls_and_evalute_responses
  end

  private
    #
    #
    # AppleStore Request call & response
    #
    #
    def execute_api_calls_and_evalute_responses
      apple_store_response.valid? ? evaluate_apple_lookup_api_call : apple_store_response.error
    end

    def apple_store_response
      @apple_store_response ||= Response::AppleStoreResponse.new(get_top_apps_from_apple_store, self.monetization)
    end

    def get_top_apps_from_apple_store
      @apple_store_result   ||= Client::AppleStoreApi.new(self.category_id, self.monetization).get_top_apps
    end

    def top_charts_for_monetization_type
      apple_store_response.top_charts_for_monetization
    end
    #
    #
    # AppleLookupApi call & response
    #
    #
    def evaluate_apple_lookup_api_call
      apple_lookup_response.valid? ? apple_lookup_response.build_top_apps_response : apple_lookup_response.error
    end

    def apple_lookup_response
      @apple_lookup_response ||= Response::AppleLookupResponse.new( get_app_metadata )
    end

    def get_app_metadata
      @apple_lookup_result   ||= Client::AppleLookupApi.new( top_charts_for_monetization_type ).get_apps_metadata
    end

end