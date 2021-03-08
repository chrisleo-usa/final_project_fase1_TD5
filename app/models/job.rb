class Job < ApplicationRecord
  belongs_to :company

  has_many :enrollments
  has_many :candidates, through: :enrollments

  enum level: { intern: 0, junior: 1, full: 2, senior: 3 }
  enum type_hiring: { clt: 0, pj: 3, clt_pj: 4 }
  enum status: { active: 0, inactive: 4 }

  validates :title, :description, :salary_range, :level, :type_hiring, :requirements, :deadline_application, :total_vacancies, presence: true

  def applied(candidate)
    return false if self.candidates.exists?(candidate.id)
    Enrollment.create!(job: self, candidate: candidate)
  end
end
