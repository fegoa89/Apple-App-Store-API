class PublishersRanking < Base
  private
    def evaluate_apple_lookup_api_call
      if apple_lookup_response.valid?
        apple_lookup_response.get_publishers_ranking
      else
        apple_lookup_response.error
      end
    end
end