require 'rails_helper'

feature 'Employee approve a enrollment' do
  scenario 'but the enrollment is already approved' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)

    login_as employee, scope: :employee
    visit company_job_path(company, job)
    click_on enrollment.candidate.name
    click_on 'Approve'

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_content('Candidate already approved!')
  end

  scenario 'and see a form to make a proposal' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit company_job_path(company, job)
    click_on enrollment.candidate.name
    click_on 'Approve'

    approve = Approve.last
    expect(current_path).to eq(new_enrollment_approved_path(enrollment, approve))
    within('form') do
      expect(page).to have_content('Proposal message')
      expect(page).to have_content('Proposal salary')
      expect(page).to have_content('Start date')
      expect(page).to have_button('Send')
    end
  end

  scenario 'but the proposal form cannot be blank' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit new_enrollment_approved_path(enrollment, approve)
    within 'form' do
      fill_in 'Proposal message', with: ''
      fill_in 'Proposal salary', with: ''
      fill_in 'Start date', with: ''
      click_on 'Save'
    end

    expect(current_path).to eq(enrollment_approved_path(enrollment, approve))
    #testando
    expect(page).to have_content('Congratz, you have been selected')
    expect(page).to have_content('5000.0')
    expect(page).to have_content('01/07/2021')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit new_enrollment_approved_path(enrollment, approve)
    within 'form' do
      fill_in 'Proposal message', with: 'Congratz, you have been selected'
      fill_in 'Proposal salary', with: '5000.0'
      fill_in 'Start date', with: '01/07/2021'
      click_on 'Save'
    end

    expect(current_path).to eq(enrollment_approved_path(enrollment, approve))
    expect(page).to have_content('Congratz, you have been selected')
    expect(page).to have_content('5000.0')
    expect(page).to have_content('01/07/2021')
  end
end