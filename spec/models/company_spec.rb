require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'validation' do
    it { should validate_presence_of(:name).on(:edit) }
    it { should validate_presence_of(:address).on(:edit) }
    it { should validate_presence_of(:complement).on(:edit) }
    it { should validate_presence_of(:city).on(:edit) }
    it { should validate_presence_of(:state).on(:edit) }
    it { should validate_presence_of(:site).on(:edit) }
    it { should validate_presence_of(:cnpj).on(:edit) }
    it { should validate_presence_of(:social_media).on(:edit) }
    it { should_not validate_presence_of(:logo) }

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
