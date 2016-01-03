class PublishersRanking < Base
  private
    def evaluate_apple_lookup_api_call
      apple_lookup_response.valid? ? apple_lookup_response.get_publishers_ranking : apple_lookup_response.error
    end
end