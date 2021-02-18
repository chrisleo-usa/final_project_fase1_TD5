require 'rails_helper'

feature 'The first employee to register' do
  scenario 'after registration is redirect to register the company' do
    visit root_path
    click_on 'Login'
    click_on 'Employee'
    click_on 'Sign up'
    within('form') do
      fill_in 'Email', with: 'chris@campuscode.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
    end

    expect(current_path).to eq (new_company_path)
  end

  scenario 'successfully register his company' do
    Employee.create!(email: 'chris@campuscode.com', password: '123456')

    visit new_company_path
    within('form') do
      fill_in 'Company name', with: 'Campus Code'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'tdlogo.png')
      fill_in 'Address', with: 'rua são paulo'
      fill_in 'CNPJ', with: '12345678910112'
      fill_in 'Website', with: 'www.campuscode.com.br'
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