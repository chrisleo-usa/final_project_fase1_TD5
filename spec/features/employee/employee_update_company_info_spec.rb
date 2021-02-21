require 'rails_helper'

feature 'Admin employee update company info' do
  scenario 'and must be signed in' do
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456')

    login_as employee, scope: :employee
    visit root_path

    expect(page).not_to have_link('Login')
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end

  scenario 'successfully' do
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456')
    company = Company.create!(name: 'TreinaDev', address: 'Rua Vitoria regia, 222', cnpj: 1234567891011, site: 'www.treinadev.com.br', social_media: 'www.instagram.com/treinadev')

    login_as employee, scope: :employee
    visit root_path
    click_on 'My company'
    click_on 'edit'
    within 'form' do
      fill_in 'Company name', with: 'Campus Code'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'ruby.jpeg')
      fill_in 'Address', with: 'Rua São Paulo'
      fill_in 'CNPJ', with: '987654321014'
      fill_in 'Website', with: 'www.campuscode.com.br'
      fill_in 'Social media', with: 'www.linkedin.com/in/campuscode'
      click_on 'Save'
    end

    expect(current_path).to eq(company_path(company.id))
    expect(page).to have_content('Campus Code')
    expect(page).to have_content('Rua São Paulo')
    expect(page).to have_content('987654321014')
    expect(page).to have_content('www.campuscode.com.br')
    expect(page).to have_content('www.linkedin.com/in/campuscode')
    expect(page).to have_css('img[src*="ruby.jpeg"]')
    expect(page).no_to have_content('TreinaDev')
  end
end