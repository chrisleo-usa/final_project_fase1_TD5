require 'rails_helper'

feature 'Candidate apply for a job' do
  scenario 'must be signed in' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    visit root_path
    click_on 'Login'
    click_on 'Candidate'
    within('form') do
      fill_in 'Email', with: candidate.email
      fill_in 'Password', with: candidate.password
      click_on 'Log in'
    end

    expect(current_path).to eq(candidate_path(candidate))
  end

  scenario 'successfully' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'Companies'
    click_on company.name
    click_on job.title
    click_on 'Apply for this job'

    enrollment = Enrollment.last
    expect(current_path).to eq(candidate_enrollments_path(candidate))
    expect(page).to have_content('Successfully applied')
    expect(page).to have_content(enrollment.job.title)
  end

  scenario 'and see all applications' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    campus_company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    ruby_job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: campus_company)

    treinadev_company = Company.create!(name: 'Treina Dev', address: 'Rua dos Devs, 666', cnpj: 987654321, 
                                    site: 'www.treinadev.com.br', social_media: 'www.linkedin.com/in/treinadev', 
                                    domain: 'treinadev')

    js_job = Job.create!(title: 'Javascript Developer', description: 'Vaga para Javascript Developer',
                          salary_range: 7500.0, requirements: 'Conhecimento sólido em Javascript, HTML e CSS',
                          deadline_application: '10/04/2023', total_vacancies: 2, level: 2, company: treinadev_company)

    ruby_enrollment = Enrollment.create!(job: ruby_job, candidate: candidate)
    js_enrollment = Enrollment.create!(job: js_job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'My profile'
    click_on 'My applications'

    expect(current_path).to eq(candidate_enrollments_path(candidate))
    expect(page).to have_content(js_job.title)
    expect(page).to have_content(ruby_job.title)
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

    Enrollment.create!(job: job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'My profile'
    click_on 'My applications'
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
  end
end