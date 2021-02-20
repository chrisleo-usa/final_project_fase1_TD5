class Job < ApplicationRecord

  enum level: {intern: 0, junior: 1, pleno: 2, senior: 3}

  validates :title, :description, :salary_range, :requirements, :deadline_application, :total_vacancies, presence: true
end
