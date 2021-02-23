require 'rails_helper'

feature 'Employee can update attributes' do
  scenario 'and must be signed in' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit root_path

    expect(page).not_to have_link('Login')
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end

  scenario 'but attributes cannot be blank' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)
    Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'
    click_on 'Ruby on Rails Developer'
    click_on 'Edit'
    within('form') do
      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      fill_in 'Salary range', with: ''
      fill_in 'Requirements', with: ''
      fill_in 'Deadline application', with: ''
      fill_in 'Total vacancies', with: ''
      click_on 'Save'
    end

    job = Job.last
    expect(current_path).to eq(company_job_path(job.company, job))
    expect(page).to have_content('There were problems with the following fields')
    expect(page).to have_content('Title can\'t be blank')
    expect(page).to have_content('Description can\'t be blank')
    expect(page).to have_content('Salary range can\'t be blank')
    expect(page).to have_content('Requirements can\'t be blank')
    expect(page).to have_content('Deadline application can\'t be blank')
    expect(page).to have_content('Total vacancies can\'t be blank')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)
    Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'
    click_on 'Ruby on Rails Developer'
    click_on 'Edit'
    within('form') do
      fill_in 'Title', with: 'Desenvolvedor Front-End'
      fill_in 'Description', with: 'Vaga de emprego para Desenvolvedor Front-End'
      fill_in 'Salary range', with: 7000.0
      select 'Senior', from: 'Job level'
      fill_in 'Requirements', with: 'Conhecimento sólido em Javascript, CSS, HTML, Bootstrap, Gulp e React'
      fill_in 'Deadline application', with: '25/10/2023'
      fill_in 'Total vacancies', with: 10
      click_on 'Save'
    end
    click_on 'Desenvolvedor Front-End'

    job = Job.last
    expect(current_path).to eq(company_job_path(job.company, job))
    expect(page).not_to have_content('Ruby on Rails Developer')
    expect(page).not_to have_content('Vaga para Ruby on Rails Developer')
    expect(page).not_to have_content(9000.0)
    expect(page).not_to have_content('Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3')
    expect(page).not_to have_content('10/04/2023')
    expect(page).not_to have_content('junior')
    expect(page).not_to have_content('pleno')
    expect(page).not_to have_content('intern')

    expect(page).to have_content('Desenvolvedor Front-End')
    expect(page).to have_content('Vaga de emprego para Desenvolvedor Front-End')
    expect(page).to have_content(7000.0)
    expect(page).to have_content('Conhecimento sólido em Javascript, CSS, HTML, Bootstrap, Gulp e React')
    expect(page).to have_content('25/10/2023')
    expect(page).to have_content('senior')
  end
end