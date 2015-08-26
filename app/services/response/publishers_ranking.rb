module Response
  class PublishersRanking

    attr_accessor :results

    def initialize(results)
      @results = results
    end

    def build_hash
      hash_with_metadata
      sort_array
      set_rank_position
    end

    private

      def hash_with_metadata
        publishers_hash = {}
        results.each do |result|
          publisher          = publishers_hash[ result[:metadata][:publisher_id] ] || {}
          if publisher.empty?
            publisher_metadata         = result[:metadata]
            publisher[:app_names]      = [ publisher_metadata[:app_name] ]
            publisher[:publisher_id]   = publisher_metadata[:publisher_id]
            publisher[:publisher_name] = publisher_metadata[:publisher_name]
            publisher[:number_of_apps] = 1
          else
            publisher[:app_names]      << result[:metadata][:app_name]
            publisher[:number_of_apps] += 1
          end
            publishers_hash[ result[:metadata][:publisher_id]] = publisher
        end
        publishers_hash
      end

      def sort_array
        @sorted_hash ||= hash_with_metadata.values.sort_by {|k| k[:number_of_apps]}.reverse!
      end

      def set_rank_position
        0.upto(sort_array.count-1) { |i| sort_array[i][:ranking_position] = i+1 }
        sort_array
      end
  end
end