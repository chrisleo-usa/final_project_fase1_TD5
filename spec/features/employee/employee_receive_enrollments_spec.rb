require 'rails_helper'

feature 'Employee can see enrollments' do
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
    click_on 'Empresas'
    click_on company.name
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_link(candidate.name)
  end

  scenario 'but unfortunately there is none' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job)) 
    expect(page).to have_content('Sem inscrições no momento')
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

    other_candidate = Candidate.create!(name: 'Susan', phone: '498877445522', cpf: 987654321,
                                  biography: 'Desenvolvedora Full stack',
                                  email: 'susan@gmail.com', password: '123456')

    enrollment = Enrollment.create!(job: job, candidate: candidate)
    another_enrollment = Enrollment.create!(job: job, candidate: other_candidate)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_content('Inscrições recebidas:')
    expect(page).to have_link(candidate.name)
    expect(page).to have_link(other_candidate.name)
  end

  scenario 'and view enrollment details' do
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
    visit root_path
    click_on 'Minha empresa'
    click_on job.title
    click_on candidate.name

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_css('h2.dashboard__name', text: "Inscrição de #{enrollment.candidate.name} para a vaga de #{enrollment.job.title}")
    within('div.dashboard__grid') do
      expect(page).to have_css('p.dashboard__attribute', text: candidate.name)
      expect(page).to have_css('p.dashboard__attribute', text: candidate.email)
      expect(page).to have_css('p.dashboard__attribute', text: candidate.phone)
      expect(page).to have_css('p.dashboard__attribute', text: candidate.biography)

      expect(page).to have_css('p.dashboard__attribute', text: job.title)
      expect(page).to have_css('p.dashboard__attribute', text: job.description)
      expect(page).to have_css('p.dashboard__attribute', text: job.level)
      expect(page).to have_css('p.dashboard__attribute', text: job.salary_range)
      expect(page).to have_css('p.dashboard__attribute', text: job.requirements)
    end
  end
end