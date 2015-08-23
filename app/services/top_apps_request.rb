class TopAppsRequest

  include               ActiveModel::Model
  attr_accessor         :category_id, :monetization, :apple_store_request
  validates_presence_of :category_id, :monetization

  def perform_request
    get_top_apps_from_apple_store

    if apple_store_response.valid?
      top_charts_for_monetization_type
    else
      # Return error
      {
        error:    400,
        message: "Bad Request"
      }
    end
  end

  private

    def top_charts_for_monetization_type
      apple_store_response.top_charts_for_monetization
    end

    def apple_store_response
      @apple_store_response ||= Response::AppleStoreResponse.new(apple_store_request, self.monetization)
    end

    def get_top_apps_from_apple_store
      @apple_store_request  ||= Client::AppleStoreApi.new(self.category_id, self.monetization).get_top_apps
    end

end