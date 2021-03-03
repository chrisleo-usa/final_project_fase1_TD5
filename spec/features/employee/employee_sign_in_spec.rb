require 'rails_helper'

feature 'Employee sign in' do
  scenario 'but email or password are invalid' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    within('form.log_in__form') do
      fill_in 'Email', with: 'joao@campuscode.com'
      fill_in 'Senha', with: '111111'
      click_on 'Entrar'
    end

    expect(current_path).to eq(employee_session_path)
    expect(page).to have_content('Email ou senha inválidos')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    within('form.log_in__form') do
      fill_in 'Email', with: employee.email
      fill_in 'Senha', with: employee.password
      click_on 'Entrar'
    end

    expect(current_path).to eq(company_path(employee.company))
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end
end