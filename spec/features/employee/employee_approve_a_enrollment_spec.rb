require 'rails_helper'

feature 'Employee approve a enrollment' do
  scenario 'and must be signed in to see enrollments of candidates' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)

    visit root_path
    click_on 'Companies'
    click_on company.name
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_link(candidate.name)
  end

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
    proposal = Proposal.create!(proposal_message: 'Congratulations, you have been approved, check this proposal', proposal_salary: 7000.0,
                                start_date: '20/04/2023', enrollment: enrollment)

    login_as employee, scope: :employee
    visit company_job_path(company, job)
    click_on candidate.name
    click_on 'Approve'

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_css('span.dashboard__status', text: 'approved')
    expect(page).to have_content('Candidate is already approved!')
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
    click_on candidate.name
    click_on 'Approve'

    proposal = Proposal.last
    expect(current_path).to eq(new_enrollment_proposal_path(enrollment, proposal))
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
    visit company_job_path(company, job)
    click_on candidate.name
    click_on 'Approve'
    within 'form.create__form' do
      fill_in 'Proposal message', with: ''
      fill_in 'Proposal salary', with: ''
      fill_in 'Start date', with: ''
      click_on 'Send'
    end

    expect(current_path).to eq(enrollment_proposals_path(enrollment))
    within('div.warnings') do
      expect(page).to have_css('li.alert', text: 'Proposal message can\'t be blank')
      expect(page).to have_css('li.alert', text: 'Proposal salary can\'t be blank')
      expect(page).to have_css('li.alert', text: 'Start date can\'t be blank')
    end
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

    enrollment = Enrollment.create!(job: job, candidate: candidate, status: 0)

    login_as employee, scope: :employee
    visit company_job_path(company, job)
    click_on candidate.name
    click_on 'Approve'
    within 'form.create__form' do
      fill_in 'Proposal message', with: 'Congratulations, you have been approved'
      fill_in 'Proposal salary', with: '6000.0'
      fill_in 'Start date', with: '10/04/2023'
      click_on 'Send'
    end

    enrollment.reload
    proposal = Proposal.last
    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_css('span.dashboard__status', text: enrollment.status)
    within('div.response__item') do
      expect(page).to have_css('p.response__attribute', text: 'Congratulations, you have been approved')
      expect(page).to have_css('p.response__attribute', text: '6000.0')
      expect(page).to have_css('p.response__attribute', text: '10/04/2023')
    end
    #TODO: continuar teste
  end
end