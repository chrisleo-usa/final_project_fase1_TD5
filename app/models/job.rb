class Job < ApplicationRecord
  belongs_to :company

  has_many :enrollments
  has_many :candidates, through: :enrollments

  enum level: { intern: 0, junior: 1, pleno: 2, senior: 3 }
  enum status: { active: 0, inactive: 4 }

  validates :title, :description, :salary_range, :level, :requirements, :deadline_application, :total_vacancies, presence: true

  def applied(candidate)
    return false if self.candidates.exists?(candidate.id)
    Enrollment.create!(job: self, candidate: candidate)
  end
end
