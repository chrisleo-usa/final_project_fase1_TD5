class Reject < ApplicationRecord
  belongs_to :enrollment

  validates :message, presence: true
  validates :message, length: { minimum: 20 }, on: :create
end
