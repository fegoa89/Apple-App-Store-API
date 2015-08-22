class TopAppsRequest

  include               ActiveModel::Model
  attr_accessor         :category_id, :monetization
  validates_presence_of :category_id, :monetization

  def perform_request
    "hey"
  end
end