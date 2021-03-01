class Enrollment < ApplicationRecord
  belongs_to :job
  belongs_to :candidate
  has_one :proposal
  has_one :reject

  enum status: { pending: 0, approved: 3, denied: 4 }
end
