require 'rails_helper'

RSpec.describe Candidate, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      candidate = Candidate.new

      expect(candidate.valid?).to eq(false)
      expect(candidate.errors.count).to eq(6)
    end

    it 'email must be unique' do
      Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                        biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                        email: 'chris@campuscode.com.br', password: '123456')

      candidate = Candidate.new(email: 'chris@campuscode.com.br')

      expect(candidate.valid?).to eq(false)
      expect(candidate.errors[:email]).to include('has already been taken')
    end

    it 'create a valid candidate' do
      candidate = Candidate.new(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
        biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
        email: 'chris@campuscode.com.br', password: '123456')

      expect(candidate).to be_valid
    end
  end

  context 'Delete #destroy' do
    it 'delete account' do
      candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                    biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                    email: 'chris@campuscode.com.br', password: '123456')

      Candidate.destroy(candidate.id)

      expect(Candidate.count).to eq(0)
    end
  end
end
