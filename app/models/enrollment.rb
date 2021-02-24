class Enrollment < ApplicationRecord
  belongs_to :job
  belongs_to :candidate

  enum status: { pending: 0, approved: 3, denied: 4 }
end
