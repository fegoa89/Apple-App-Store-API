class Base

  include                   ActiveModel::Model

  attr_accessor             :category_id,
                            :monetization,
                            :apple_store_result,
                            :apple_lookup_result

  validates_presence_of     :category_id,
                            :monetization

  validates :monetization,  inclusion:    { in:      %w(paid free grossing),
                                            message: "%{value} is not a valid monetization type" }

  validates :category_id ,  numericality: { only_integer: true }

end