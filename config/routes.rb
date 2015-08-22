Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
        controller :categories do
          get '/categories/top_apps'                => 'categories#top_apps'
          get '/categories/publishers_ranking'      => 'categories#publishers_ranking'
          get '/categories/app_by_ranking_position' => 'categories#app_by_ranking_position'
        end
    end
  end
end
