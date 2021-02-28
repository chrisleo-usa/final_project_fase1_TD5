class Proposal < ApplicationRecord
  belongs_to :enrollment

  validates :proposal_message, :proposal_salary, :start_date, presence: true
  validates :proposal_message, length: { minimum: 10}, on: :create

  enum status: { pending: 0, accepted: 3, refused: 4 }
end
