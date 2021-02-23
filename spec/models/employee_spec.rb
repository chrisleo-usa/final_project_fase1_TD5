require 'rails_helper'

RSpec.describe Employee, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      employee = Employee.new

      expect(employee.valid?).to eq(false)
      expect(employee.errors.count).to eq(3)
    end

    it 'email must be unique' do
      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')

      Employee.create!(email: 'chris@campus.com.br', password: '123456', company: company)
      employee = Employee.new(email: 'chris@campus.com.br')

      expect(employee.valid?).to eq(false)
      expect(employee.errors[:email]).to include('has already been taken')
    end
  end
end
