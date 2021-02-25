require 'rails_helper'
#TODO: Verificar o PromotionApproval do promotion system, sistema parecido para essa questão de aprovação e reprovação. 
feature 'A employee disapprove a enrollment' do
  scenario 'and must be signed in' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011,
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode',
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company)

    login_as employee, scope: :employee
    visit root_path

    expect(page).not_to have_link('Login')
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end

  scenario 'and message cannot be blank' do
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
    click_on 'Disapproved'
    within 'form' do
      fill_in 'Message', with: ''
      click_on 'Send'
    end

    expect(current_path.to eq(candidate_disapprove_path(candidate, Disapprove.last)))
    # expect(current_path).to eq(candidate_new_disapprove_path(candidate, Disapprove.last))

  end

  xscenario 'successfully' do

  end
end