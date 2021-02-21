class Company < ApplicationRecord
  has_many :employees
  has_one_attached :logo
end
