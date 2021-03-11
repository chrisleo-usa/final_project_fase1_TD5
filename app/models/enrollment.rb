class Enrollment < ApplicationRecord
  belongs_to :job
  belongs_to :candidate
  has_one :proposal, dependent: :destroy
  has_one :reject, dependent: :destroy

  enum status: { pending: 0, approved: 3, denied: 4 }
end
