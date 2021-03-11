class Company < ApplicationRecord
  has_many :employees, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_one_attached :logo

  validates :name, :address, :complement, :city, :state,
            :site, :cnpj, :social_media, presence: true, on: %i[edit update]
end
