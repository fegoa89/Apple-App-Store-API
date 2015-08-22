class InputParamsForRequest

  attr_accessor :params, :controller

  REQUEST_CONFIGURATION = { 
    top_apps:             [ "category_id", "monetization" ],
    publishers_ranking:   [ "category_id", "monetization", "rank_position" ],
    app_by_rank_position: [ "category_id", "monetization" ]
  }

  def initialize(params, controller_name)
    @params = params
    @controller = format_controller_name(controller_name)
  end

  def valid_params_for_request?
    binding.pry
  end

  def params_keys
    params.keys
  end


  private

    def format_controller_name(name)
      # Transform "Api::V1::TopAppsController" to "top_apps" 
      name.gsub("Api::V1::", "").chomp("Controller").split(/(?=[A-Z])/).join('_').downcase
    end
end