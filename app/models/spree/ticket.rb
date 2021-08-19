class Spree::Ticket < ApplicationRecord
    mount_uploader :picture, TicketPictureUploader
    has_rich_text :body
    belongs_to :user, :optional => true
end
