module Client
  class AppleStoreApi

    attr_accessor :category_id, :monetization, :response

    def initialize(category_id, monetization)
      @category_id  = category_id
      @monetization = monetization
    end

    def get_top_apps
      apple_store_client_request
    end

    private
    
      def apple_store_client_request
        @response ||= RestClient.get request_configuration.request_url, request_configuration.apple_store_header
      end

      def request_configuration
        @client_config ||= Request::ConfigureApiRequest.new( { category_id: category_id, monetization: monetization } )
      end

  end
end