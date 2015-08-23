module Response
  class AppleStoreResponse

    attr_accessor :response, :monetization

    MONETIZATION_POSITION = { "paid" => 0, "free" => 1, "grossing" => 2 }

    def initialize(response, monetization_string)
      @response     = response
      @monetization = monetization_string
    end

    def valid?
      # when a invalid request is performed, it returns and XML response
      # that determines the error failureType
      !response.body.include?("failureType")
    end

    def error
      { error: 400, message: "Bad Request" }
    end

    def top_charts_for_monetization
      top_charts_array[monetization_array_position]["adamIds"]
    end

    private

      def monetization_array_position
        MONETIZATION_POSITION[monetization]
      end

      def top_charts_array
        formatted_response["topCharts"]
      end

      def formatted_response
        @json_response = JSON.parse(response)
      end
  end
end