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
    click_on 'Minha empresa'

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
    click_on 'Editar'
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: ''
      attach_file 'Logo', Rails.root.join('spec', 'support', 'ruby.jpeg')
      fill_in 'Endereço', with: ''
      fill_in 'CNPJ', with: '987654321014'
      fill_in 'Site', with: ''
      fill_in 'Redes sociais', with: 'www.linkedin.com/in/campuscode'
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content('Nome da empresa não pode ficar em branco')
    expect(page).to have_content('Endereço não pode ficar em branco')
    expect(page).to have_content('Site não pode ficar em branco')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    login_as employee, scope: :employee
    visit edit_company_path(company)
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: 'TreinaDev'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'ruby.jpeg')
      fill_in 'Endereço', with: 'Rua do TreinaDev'
      fill_in 'Complemento', with: '225, sala 01'
      fill_in 'Cidade', with: 'São Paulo'
      fill_in 'Estado', with: 'SP'
      fill_in 'CNPJ', with: '987654321014'
      fill_in 'Site', with: 'www.treinadev.com.br'
      fill_in 'Redes sociais', with: 'www.linkedin.com/in/treinadev'
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_path(company.id))
    expect(page).to have_css('p.dashboard__attribute', text: 'TreinaDev')
    expect(page).to have_css('p.dashboard__attribute', text: 'Rua do TreinaDev')
    expect(page).to have_css('p.dashboard__attribute', text: '225, sala 01')
    expect(page).to have_css('p.dashboard__attribute', text: 'São Paulo')
    expect(page).to have_css('p.dashboard__attribute', text: 'SP')
    expect(page).to have_css('p.dashboard__attribute', text: '987654321014')
    expect(page).to have_css('p.dashboard__attribute', text: 'www.treinadev.com.br')
    expect(page).to have_css('p.dashboard__attribute', text: 'www.linkedin.com/in/treinadev')
    expect(page).to have_css('img[src*="ruby.jpeg"]')
    expect(page).not_to have_content(company.name)
  end
end