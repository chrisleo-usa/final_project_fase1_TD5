require 'rails_helper'

feature 'Admin employee update company info' do
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

  scenario 'regular employee cannot see edit button' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 0)

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'

    expect(current_path).to eq(company_path(company))
    expect(page).not_to have_link('Edit.create__btn')
  end

  scenario 'and name, address and site cannot be blank' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    login_as employee, scope: :employee
    visit company_path(company)
    click_on 'Edit'
    within '.create__form' do
      fill_in 'Company name', with: ''
      attach_file 'Logo', Rails.root.join('spec', 'support', 'ruby.jpeg')
      fill_in 'Address', with: ''
      fill_in 'CNPJ', with: '987654321014'
      fill_in 'Site', with: ''
      fill_in 'Social media', with: 'www.linkedin.com/in/campuscode'
      click_on 'Save'
    end

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Address can\'t be blank')
    expect(page).to have_content('Site can\'t be blank')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    login_as employee, scope: :employee
    visit edit_company_path(company)
    within '.create__form' do
      fill_in 'Company name', with: 'TreinaDev'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'ruby.jpeg')
      fill_in 'Address', with: 'Rua do TreinaDev'
      fill_in 'CNPJ', with: '987654321014'
      fill_in 'Site', with: 'www.treinadev.com.br'
      fill_in 'Social media', with: 'www.linkedin.com/in/treinadev'
      click_on 'Save'
    end

    expect(current_path).to eq(company_path(company.id))
    expect(page).to have_css('p.dashboard__attribute', text: 'TreinaDev')
    expect(page).to have_css('p.dashboard__attribute', text: 'Rua do TreinaDev')
    expect(page).to have_css('p.dashboard__attribute', text: '987654321014')
    expect(page).to have_css('p.dashboard__attribute', text: 'www.treinadev.com.br')
    expect(page).to have_css('p.dashboard__attribute', text: 'www.linkedin.com/in/treinadev')
    expect(page).to have_css('img[src*="ruby.jpeg"]')
    expect(page).not_to have_content(company.name)
  end
end