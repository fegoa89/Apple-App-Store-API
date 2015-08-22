class RequestConfiguration

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def apple_store_url
    client_configuration.urls["apple_store"]
  end

  def apple_lookup_url
    client_configuration.urls["apple_lookup"]
  end

  def concatenate_for_apple_store
    apple_store_params
  end

  def concatenate_for_apple_lookup
  end

  def apple_store_header
    apple_store_header_configuration
  end

  private

    def apple_store_params
      build_params_hash.map { |k, v| "#{k}=#{v}" }.join("&")
    end

    def build_params_hash
      {
        l:        client_configuration.language,
        popId:    client_configuration.pop_id,
        genreId:  params[:category_id],
        dataOnly: client_configuration.data_only
      }
    end

    def apple_store_header_configuration
      {
        accept: header_configuration["accept"],
        user_agent: header_configuration["user_agent"],
        cache_control: header_configuration["cache_control"],
        accept_language: header_configuration["accept_language"],
        accept_enconding: header_configuration["accept_enconding"],
        x_apple_store_front: header_configuration["x_apple_store_front"]
      }
    end

    def header_configuration
      @header_configuration ||= client_configuration.headers
    end

    def client_configuration
      @configuration ||=  Rails.application.secrets
    end

end