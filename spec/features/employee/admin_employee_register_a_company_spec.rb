require 'rails_helper'

feature 'The first employee to register need register the company as well' do
  scenario 'only the first employee can register the company' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', domain: 'campuscode')
    Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 0, company: company)

    visit root_path
    click_on 'Login'
    click_on 'Employee'
    click_on 'Sign up'
    within('form') do
      fill_in 'Email', with: 'joao@campuscode.com.br'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
    end

    expect(current_path).to eq(company_path(Employee.last.company))
    expect(page).to have_content(Employee.last.email)
    expect(page).to have_link('Logout')
    expect(page).not_to have_link('Register a job opportunity')
  end

  scenario 'view company register form' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)

    expect(current_path).to eq (edit_company_path(Employee.last.company))
    expect(page).to have_content(employee.email)
    within('form') do
      expect(page).to have_content('Company name')
      expect(page).to have_content('Logo')
      expect(page).to have_content('Address')
      expect(page).to have_content('CNPJ')
      expect(page).to have_content('Site')
      expect(page).to have_content('Social media')
      expect(page).to have_button('Save')
    end
  end

  scenario 'attributes name, address and site cannot be blank' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)
    within 'form' do
      fill_in 'Company name', with: ''
      fill_in 'Address', with: ''
      fill_in 'Site', with: ''
      click_on 'Save'
    end

    expect(current_path).to eq (company_path(Employee.last.company))
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Address can\'t be blank')
    expect(page).to have_content('Site can\'t be blank')
  end

  scenario 'successfully register his company' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)
    within 'form' do
      fill_in 'Company name', with: 'Campus Code'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'tdlogo.png')
      fill_in 'Address', with: 'rua são paulo'
      fill_in 'CNPJ', with: '12345678910112'
      fill_in 'Site', with: 'www.campuscode.com.br'
      fill_in 'Social media', with: 'www.instagram.com/treinadev'
      click_on 'Save'
    end

    expect(current_path).to eq(company_path(Company.last))
    expect(page).to have_content('Campus Code')
    expect(page).to have_content('rua são paulo')
    expect(page).to have_content('12345678910112')
    expect(page).to have_content('www.campuscode.com.br')
    expect(page).to have_content('www.instagram.com/treinadev')
    expect(page).to have_css('img[src*="tdlogo.png"]')
  end
end