class Decline < ApplicationRecord
  belongs_to :proposal

  validates :reason, presence: true
  validates :reason, length: { minimum: 10 }, on: :create
end
