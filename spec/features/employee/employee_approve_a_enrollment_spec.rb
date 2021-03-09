require 'rails_helper'

feature 'Employee approve a enrollment' do
  scenario 'and cannot see the approve button if the enrollment is already approved' do
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

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).not_to have_link('Aprovar')
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
    click_on 'Aprovar'

    proposal = Proposal.last
    expect(current_path).to eq(new_enrollment_proposal_path(enrollment, proposal))
    within('form.create__form') do
      expect(page).to have_content('Mensagem de proposta')
      expect(page).to have_content('Proposta salarial')
      expect(page).to have_content('Data de início')
      expect(page).to have_button('Enviar')
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
    click_on 'Aprovar'
    within 'form.create__form' do
      fill_in 'Mensagem de proposta', with: ''
      fill_in 'Proposta salarial', with: ''
      fill_in 'Data de início', with: ''
      click_on 'Enviar'
    end

    expect(current_path).to eq(enrollment_proposals_path(enrollment))
    within('div.warnings') do
      expect(page).to have_css('li.alert', text: 'Mensagem de proposta não pode ficar em branco')
      expect(page).to have_css('li.alert', text: 'Proposta salarial não pode ficar em branco')
      expect(page).to have_css('li.alert', text: 'Data de início não pode ficar em branco')
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
    click_on 'Aprovar'
    within 'form.create__form' do
      fill_in 'Mensagem de proposta', with: 'Parabéns, você foi aprovado!'
      fill_in 'Proposta salarial', with: '6000'
      fill_in 'Data de início', with: '10/04/2023'
      click_on 'Enviar'
    end

    enrollment.reload
    proposal = Proposal.last
    expect(current_path).to eq(proposal_path(proposal))
    expect(page).to have_css('span', text: 'Em análise')
    within('div.response__item') do
      expect(page).to have_css('p.response__attribute', text: 'Parabéns, você foi aprovado!')
      expect(page).to have_css('p.response__attribute', text: '6.000,00')
      expect(page).to have_css('p.response__attribute', text: '10/04/2023')
    end

    expect(page).not_to have_css('span', text: 'aceita')
    expect(page).not_to have_css('span', text: 'recusada')
  end
end