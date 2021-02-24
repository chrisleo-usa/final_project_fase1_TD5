require 'rails_helper'

RSpec.describe Job, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')

      job = Job.new

      expect(job.valid?).to eq(false)
      expect(job.errors.count).to eq(8)
    end

    it 'create a valid job' do
      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')
      job = Job.new(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                    salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                    deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

      expect(job).to be_valid
    end
  end

  context 'Job status' do
    it 'by default is 0 (active)' do
      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')
      job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                        salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                        deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

      expect(job.status).to eq('active')
    end

    #Está correto este teste??
    it 'is inactive when a company employee disables' do
      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')
      job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                        salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                        deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)
      job.inactive!

      job.reload
      expect(job.status).to eq('inactive')
    end
  end

  #TODO: Verificar onde melhor se encaixa esse teste! 
  xcontext '#applied' do
    it 'return false if candidate already applied' do
      company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                domain: 'campuscode')

      job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                    salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                    deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

      candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                    biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                    email: 'chris@campuscode.com.br', password: '123456')

      Enrollment.create!(job: job, candidate: candidate)
      enrollment = Enrollment.create!(job: job, candidate: candidate)
      job.applied(enrollment)

      job.reload 
      expect(job.valid?).to eq(true)
    end
  end
end
