class TopAppsRequest

  include               ActiveModel::Model
  attr_accessor         :category_id, :monetization
  validates_presence_of :category_id, :monetization

  def perform_request
    execute_api_call
  end

  private

    def execute_api_call
      RestClient.get request_configuration.apple_store_url, request_configuration.concatenate_for_apple_store, request_configuration.apple_store_header
    end

    def request_configuration
      @client_config ||= RequestConfiguration.new( { category_id: self.category_id, monetization: self.monetization } )
    end
end