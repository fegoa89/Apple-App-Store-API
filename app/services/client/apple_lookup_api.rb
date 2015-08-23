module Client
  class AppleLookupApi

    attr_accessor :ids

    def initialize(ids_array)
      @ids = ids_array
    end

    def get_apps_metadata
      apple_lookup_request
    end

    private
      def apple_lookup_request
        begin
          @response ||= RestClient.get request_configuration.apple_lookup_url
        rescue => e
          # If the request goes wrong, returns a proper error message in JSON format
          e
        end
      end

      def request_configuration
        @client_config ||= Request::ConfigureApiRequest.new( { ids: ids } )
      end
  end
end