class UserJob < ApplicationRecord
  belongs_to :user
  validates :title, uniqueness: { scope: :user, message: "You Already Saved This Job" }
end
