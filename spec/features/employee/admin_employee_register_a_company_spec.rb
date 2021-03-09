require 'rails_helper'

feature 'The first employee to register need register the company as well' do
  scenario 'only the first employee is redirect to register company' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    admin_employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    click_on 'Cadastrar'
    within 'form.create__form' do
      fill_in 'Email', with: 'joao@campuscode.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      click_on 'Salvar'
    end

    employee = Employee.last
    expect(current_path).not_to eq(edit_company_path(company))
    expect(current_path).to eq(company_path(employee.company))
    expect(page).to have_content(employee.email)
    expect(page).to have_css('h2.dashboard__title', text: "Página da empresa #{company.name}")
    expect(page).to have_link('Logout')
    expect(page).not_to have_content(admin_employee.email)
    expect(page).not_to have_link('Registrar novo emprego')
  end

  scenario 'and view company register form' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)

    expect(current_path).to eq (edit_company_path(Employee.last.company))
    expect(page).to have_content(employee.email)
    within('form.create__form') do
      expect(page).to have_content('Nome da empresa')
      expect(page).to have_content('Logo')
      expect(page).to have_content('Endereço')
      expect(page).to have_content('CNPJ')
      expect(page).to have_content('Site')
      expect(page).to have_content('Redes sociais')
      expect(page).to have_button('Salvar')
    end
  end

  scenario 'attributes name, address and site cannot be blank on edit' do
    company = Company.create!(name: 'Company name', address: 'Company address', site: 'Company site', domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', admin: 1, company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: ''
      fill_in 'Endereço', with: ''
      fill_in 'Site', with: ''
      click_on 'Salvar'
    end

    employee = Employee.last
    expect(current_path).to eq (company_path(employee.company))
    within('div.warnings') do
      expect(page).to have_content('Nome da empresa não pode ficar em branco')
      expect(page).to have_content('Endereço não pode ficar em branco')
      expect(page).to have_content('Site não pode ficar em branco')
    end
  end

  scenario 'successfully register company' do
    company = Company.create!(domain: 'campuscode')
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company, admin: 1)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: 'Campus Code'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'tdlogo.png')
      fill_in 'Endereço', with: 'rua são paulo'
      fill_in 'Complemento', with: '222, sala 603'
      fill_in 'Cidade', with: 'São Paulo'
      fill_in 'Estado', with: 'SP'
      fill_in 'CNPJ', with: '12345678910112'
      fill_in 'Site', with: 'www.campuscode.com.br'
      fill_in 'Redes sociais', with: 'www.instagram.com/treinadev'
      click_on 'Salvar'
    end

    company = Company.last
    expect(current_path).to eq(company_path(Company.last))
    within('div.dashboard__list') do
      expect(page).to have_css('p.dashboard__attribute', text: 'Campus Code')
      expect(page).to have_css('p.dashboard__attribute', text: 'rua são paulo')
      expect(page).to have_css('p.dashboard__attribute', text: '222, sala 603')
      expect(page).to have_css('p.dashboard__attribute', text: 'São Paulo')
      expect(page).to have_css('p.dashboard__attribute', text: 'SP')
      expect(page).to have_css('p.dashboard__attribute', text: '12345678910112')
      expect(page).to have_css('p.dashboard__attribute', text: 'www.campuscode.com.br')
      expect(page).to have_css('p.dashboard__attribute', text: 'www.instagram.com/treinadev')
    end
    within('div.dashboard__avatar') do
      expect(page).to have_css('img[src*="tdlogo.png"]')
    end
  end
end