class Spree::WithdrawalBalance < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :line_item, optional: true
end
