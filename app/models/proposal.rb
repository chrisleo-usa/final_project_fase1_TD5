class Proposal < ApplicationRecord
  belongs_to :enrollment

  validates :proposal_message, :proposal_salary, :start_date, presence: true
end
