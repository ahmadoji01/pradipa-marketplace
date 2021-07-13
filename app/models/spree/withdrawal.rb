class Spree::Withdrawal < ApplicationRecord
  belongs_to :user
  has_many :withdrawal_requests
end
