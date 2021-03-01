require 'rails_helper'

feature 'A employee disapprove a enrollment' do
  scenario 'can see deny button' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011,
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode',
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'
    click_on job.title
    click_on candidate.name

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_link('Deny')
  end

  scenario 'see form to fill with disapproval message' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011,
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode',
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit enrollment_path(enrollment)
    click_on 'Deny'

    expect(current_path).to eq(new_enrollment_reject_path(enrollment))
    expect(page).to have_css('form.create__form')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011,
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode',
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit enrollment_path(enrollment)
    click_on 'Deny'
    within 'form.create__form' do
      fill_in 'Message', with: 'We appreciate your application, but we are looking for a employee with more experience'
      click_on 'Send'
    end

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_content('We appreciate your application, but we are looking for a employee with more experience')
  end
end