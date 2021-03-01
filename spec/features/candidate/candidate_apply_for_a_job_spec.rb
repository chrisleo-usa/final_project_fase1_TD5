require 'rails_helper'

feature 'Candidate apply for a job' do
  scenario 'must be signed in' do
    company = Company.create!(name: 'TreinaDev', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    visit root_path
    click_on 'Companies'
    click_on company.name
    click_on job.title
    click_on 'Apply for this job'

    expect(current_path). to eq(new_candidate_session_path)
  end

  scenario 'successfully and is redirect to enrollments page' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@hotmail.com', password: '123456')

    company = Company.create!(name: 'TreinaDev', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    login_as candidate, scope: :candidate
    visit company_job_path(company, job)
    click_on 'Apply for this job'

    enrollment = Enrollment.last
    expect(current_path).to eq(candidate_enrollments_path(candidate))
    expect(page).to have_content('Successfully applied')
    within('div.index__list') do
      expect(page).to have_link(job.title)
      expect(page).to have_css('p.index__attribute', text: company.name)
      expect(page).to have_css('p.index__attribute', text: enrollment.status)
    end
  end

  scenario 'and sees enrollment job page' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@treinadev.com', password: '123456')

    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                                  site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                                  domain: 'campuscode')

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit candidate_enrollments_path(candidate)
    click_on job.title

    expect(current_path).to eq(enrollment_path(enrollment))
  end
end