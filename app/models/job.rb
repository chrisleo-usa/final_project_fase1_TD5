class Job < ApplicationRecord
  belongs_to :company

  enum level: { intern: 0, junior: 1, pleno: 2, senior: 3 }
  enum status: { active: 0, inactive: 4}

  validates :title, :description, :salary_range, :requirements, :deadline_application, :total_vacancies, presence: true
end
