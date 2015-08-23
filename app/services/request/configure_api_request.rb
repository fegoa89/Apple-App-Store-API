module Request
  class ConfigureApiRequest

    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def apple_store_header
      apple_store_header_configuration
    end

    def apple_store_url
      client_configuration.urls["apple_store"] + apple_store_params
    end

    def apple_lookup_url
      client_configuration.urls["apple_lookup"] + apple_lookup_ids
    end

    private

      def build_params_hash
        {
          l:        client_configuration.language,
          popId:    client_configuration.pop_id,
          genreId:  params[:category_id],
          dataOnly: client_configuration.data_only
        }
      end

      def apple_store_params
        build_params_hash.map { |k, v| "#{k}=#{v}" }.join("&")
      end

      def apple_lookup_ids
        "id=#{params[:ids].join(',')}"
      end

      def apple_store_header_configuration
        {
          accept:              header_configuration["accept"],
          user_agent:          header_configuration["user_agent"],
          cache_control:       header_configuration["cache_control"],
          accept_language:     header_configuration["accept_language"],
          accept_encoding:     header_configuration["accept_encoding"],
          x_apple_store_front: header_configuration["x_apple_store_front"]
        }
      end

      def client_configuration
        @configuration ||= Rails.application.secrets
      end

      def header_configuration
        @header_config ||= client_configuration.headers
      end

  end
end