class Company < ApplicationRecord
  has_many :employees
  has_one_attached :logo

  def same_company?(employee)
    !!self.employees.include?(employee)
  end

  def current_company_admin?(employee)
    !!employee.is_admin? && self.employees.include?(employee)
  end
end
