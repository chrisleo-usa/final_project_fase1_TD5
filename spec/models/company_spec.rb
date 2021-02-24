require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      company = Company.new

      expect(company.valid?).to eq(false)
      expect(company.errors.count).to eq(3)
    end

    it 'cnpj, social_media and logo are optional' do
      company = Company.new(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: '', 
                            site: 'www.campuscode.com.br', social_media: '', 
                            domain: 'campuscode')

        expect(company).to be_valid
        expect(company.errors.count).to eq(0)
    end

    it 'create a valid company' do
      company = Company.new(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                            site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                            domain: 'campuscode')

      expect(company).to be_valid
      expect(company.errors.count).to eq(0)
    end
  end
end
