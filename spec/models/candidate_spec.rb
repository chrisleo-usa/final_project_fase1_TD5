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
      expect(candidate.errors[:email]).to include('já está em uso')
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

    it 'delete account and enrollment associated' do
      candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                    biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                    email: 'chris@campuscode.com.br', password: '123456')

      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')

      job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                        salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                        deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

      enrollment = Enrollment.create!(job: job, candidate: candidate)

      Candidate.destroy(candidate.id)

      expect(Candidate.count).to eq(0)
      expect(Enrollment.count).to eq(0)
      expect(Job.count).to eq(1)
      expect(Company.count).to eq(1)
    end
  end
end
