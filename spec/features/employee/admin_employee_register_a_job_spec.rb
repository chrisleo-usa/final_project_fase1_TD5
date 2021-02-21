require 'rails_helper'

feature 'Employee admin register a job opportunity' do
  scenario 'and must be signed in' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee

    visit root_path

    expect(page).not_to have_link('Login')
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end

  scenario ', regular employee cannot register a job opportunity' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'

    expect(current_path).to eq(company_path(company))
    expect(page).not_to have_link('Register a job opportunity')
  end

  scenario 'attributes cannot be blank' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'
    click_on 'Register a job opportunity'
    within 'form' do
      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      fill_in 'Salary range', with: ''
      fill_in 'Requirements', with: ''
      fill_in 'Deadline application', with: ''
      fill_in 'Total vacancies', with: ''
      click_on 'Save'
    end

    expect(current_path).to eq(jobs_path)
    within("div.alert") do
      expect(page).to have_content('There were problems with the following fields')
      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Description can\'t be blank')
      expect(page).to have_content('Salary range can\'t be blank')
      expect(page).to have_content('Requirements can\'t be blank')
      expect(page).to have_content('Deadline application can\'t be blank')
      expect(page).to have_content('Total vacancies can\'t be blank')
    end
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'
    click_on 'Register a job opportunity'
    within('form') do
      fill_in 'Title', with: 'Dev Front-End'
      fill_in 'Description', with: 'Vaga para desenvolvedor Front End'
      fill_in 'Salary range', with: 3000.00
      select 'Intern', from: 'Job level'
      fill_in 'Requirements', with: 'Necessário Javascript, React, Rails, Php, Python, Java e etc...'
      fill_in 'Deadline application', with: '20/01/2050'
      fill_in 'Total vacancies', with: 5
      click_on 'Save'
    end

    job = Job.last
    expect(current_path).to eq(job_path(job))
    expect(page).to have_content('Dev Front-End')
    expect(page).to have_content('Vaga para desenvolvedor Front End')
    expect(page).to have_content('3000.0')
    expect(page).to have_content('Necessário Javascript, React, Rails, Php, Python, Java e etc...')
    expect(page).to have_content('20/01/2050')
    expect(page).to have_content('Intern')
    expect(page).not_to have_content('Junior')
    expect(page).not_to have_content('Pleno')
    expect(page).not_to have_content('Senior')
  end
end