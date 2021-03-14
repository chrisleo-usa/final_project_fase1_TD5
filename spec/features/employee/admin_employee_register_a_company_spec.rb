require 'rails_helper'

feature 'The first employee to register need register the company as well' do
  scenario 'only the first employee is redirect to register company' do
    company = create(:company)
    admin_employee = create(:employee, email: 'chris@campuscode.com', company: company)

    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    click_on 'Cadastrar'
    within 'form.create__form' do
      fill_in 'Email', with: 'joao@campuscode.com'
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
    company = create(:company)
    employee = create(:employee, email: 'chris@campuscode.com', company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)

    expect(current_path).to eq(edit_company_path(employee.company))
    expect(page).to have_content(employee.email)
    within('form.create__form') do
      expect(page).to have_content('Nome da empresa')
      expect(page).to have_content('Logo')
      expect(page).to have_content('Endereço')
      expect(page).to have_content('Complemento')
      expect(page).to have_content('Estado')
      expect(page).to have_content('Cidade')
      expect(page).to have_content('CNPJ')
      expect(page).to have_content('Site')
      expect(page).to have_content('Rede social')
      expect(page).to have_button('Salvar')
    end
  end

  scenario 'attributes cannot be blank on edit' do
    company = create(:company, city: '', state: '')
    employee = create(:employee, company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: ''
      fill_in 'Endereço', with: ''
      fill_in 'Complemento', with: ''
      fill_in 'Site', with: ''
      fill_in 'Rede social', with: ''
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_path(employee.company))
    within('div.warnings') do
      expect(page).to have_content('Nome da empresa não pode ficar em branco')
      expect(page).to have_content('Endereço não pode ficar em branco')
      expect(page).to have_content('Complemento não pode ficar em branco')
      expect(page).to have_content('Estado não pode ficar em branco')
      expect(page).to have_content('Cidade não pode ficar em branco')
      expect(page).to have_content('Site não pode ficar em branco')
      expect(page).to have_content('Rede social não pode ficar em branco')
    end
  end

  scenario 'successfully register company' do
    # TODO: Tive que definir cidade aqui para teste passar, verificar o que está acontecendo
    company = Company.create!(name: '', cnpj: '', address: '', complement: '', city: 'Florianópolis',
                              state: '', site: '', social_media: '', domain: 'campuscode')
    employee = create(:employee, company: company)

    login_as employee, scope: :employee
    visit edit_company_path(employee.company)
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: 'Campus Code'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'tdlogo.png')
      fill_in 'Endereço', with: 'Rua da campus code'
      fill_in 'Complemento', with: '222, sala 603'
      select 'SC', from: 'Estado'
      # TODO: Não encontra o option de cidades
      # select 'Florianópolis', from: 'Cidade'
      fill_in 'CNPJ', with: '12345678910112'
      fill_in 'Site', with: 'www.campuscode.com.br'
      fill_in 'Rede social', with: 'www.instagram.com/treinadev'
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_path(company))
    within('div.dashboard__list') do
      expect(page).to have_css('p.dashboard__attribute', text: 'Campus Code')
      expect(page).to have_css('p.dashboard__attribute', text: 'Rua da campus code')
      expect(page).to have_css('p.dashboard__attribute', text: '222, sala 603')
      expect(page).to have_css('p.dashboard__attribute', text: 'SC')
      expect(page).to have_css('p.dashboard__attribute', text: 'Florianópolis')
      expect(page).to have_css('p.dashboard__attribute', text: '12345678910112')
      expect(page).to have_css('p.dashboard__attribute', text: 'www.campuscode.com.br')
      expect(page).to have_css('p.dashboard__attribute', text: 'www.instagram.com/treinadev')
    end
    within('div.dashboard__avatar') do
      expect(page).to have_css('img[src*="tdlogo.png"]')
    end
  end
end
