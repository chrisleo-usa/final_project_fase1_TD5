class Accept < ApplicationRecord
  belongs_to :proposal

  validates :start_date, presence: true
end
