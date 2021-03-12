require 'rails_helper'

RSpec.describe Employee, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      employee = Employee.new

      expect(employee.valid?).to eq(false)
      expect(employee.errors.count).to eq(3)
    end

    it 'email must be unique' do
      company = create(:company)
      create(:employee, email: 'chris@campus.com.br', company: company)
      employee = Employee.new(email: 'chris@campus.com.br')

      expect(employee.valid?).to eq(false)
      expect(employee.errors[:email]).to include('já está em uso')
    end

    it 'create a valid employee' do
      company = create(:company)

      employee = create(:employee, company: company)

      expect(employee).to be_valid
    end
  end
end
