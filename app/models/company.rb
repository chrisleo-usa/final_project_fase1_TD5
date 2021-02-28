class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_one_attached :logo

  validates :name, :address, :site, presence: true, on: %i[index show edit update]
end
