class AppRankingPosition < Base

  attr_accessor  :rank_position

  validates      :rank_position, numericality: {  only_integer:             true,
                                                  greater_than_or_equal_to: 1   ,
                                                  less_than_or_equal_to:    200  }

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
end