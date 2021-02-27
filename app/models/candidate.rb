class Candidate < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :jobs, through: :enrollments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, :cpf, :phone, :biography, presence: true
end
