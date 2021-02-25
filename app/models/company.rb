class Company < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_one_attached :logo

  validates :name, :address, :site, presence: true, on: %i[index show edit update]
end
