require 'rails_helper'

feature 'Admin employee update company info' do
  scenario 'but must be signed in to see edit button' do
    company = create(:company, name: 'Campus Code')

    visit root_path
    click_on 'Empresas'
    click_on company.name

    expect(current_path).to eq(company_path(company))
    expect(page).not_to have_link('Editar')
  end

  scenario 'regular employee cannot see edit button' do
    company = create(:company)
    employee = create(:employee, company: company, admin: 0)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'

    expect(current_path).to eq(company_path(company))
    expect(page).not_to have_link('Editar')
  end

  scenario 'and attributes cannot be blank' do
    company = create(:company)
    employee = create(:employee, company: company, admin: 1)

    login_as employee, scope: :employee
    visit company_path(company)
    click_on 'Editar'
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: ''
      fill_in 'Endereço', with: ''
      fill_in 'Complemento', with: ''
      fill_in 'CNPJ', with: ''
      fill_in 'Site', with: ''
      fill_in 'Rede social', with: ''
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_path(company))
    within('div.warnings') do
      expect(page).to have_content('Nome da empresa não pode ficar em branco')
      expect(page).to have_content('Endereço não pode ficar em branco')
      expect(page).to have_content('Complemento não pode ficar em branco')
      expect(page).to have_content('CNPJ não pode ficar em branco')
      expect(page).to have_content('Site não pode ficar em branco')
      expect(page).to have_content('Rede social não pode ficar em branco')
    end
  end

  scenario 'successfully' do
    company = create(:company, name: 'Campus Code')
    employee = create(:employee, company: company, admin: 1)

    login_as employee, scope: :employee
    visit edit_company_path(company)
    within 'form.create__form' do
      fill_in 'Nome da empresa', with: 'TreinaDev'
      attach_file 'Logo', Rails.root.join('spec', 'support', 'ruby.jpeg')
      fill_in 'Endereço', with: 'Rua do TreinaDev'
      fill_in 'Complemento', with: '225, sala 01'
      select 'Florianópolis', from: 'Cidade'
      select 'SC', from: 'Estado'
      fill_in 'CNPJ', with: '987654321014'
      fill_in 'Site', with: 'www.treinadev.com.br'
      fill_in 'Rede social', with: 'www.linkedin.com/in/treinadev'
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_path(company.id))
    expect(page).to have_css('p.dashboard__attribute', text: 'TreinaDev')
    expect(page).to have_css('p.dashboard__attribute', text: 'Rua do TreinaDev')
    expect(page).to have_css('p.dashboard__attribute', text: '225, sala 01')
    expect(page).to have_css('p.dashboard__attribute', text: 'Florianópolis')
    expect(page).to have_css('p.dashboard__attribute', text: 'SC')
    expect(page).to have_css('p.dashboard__attribute', text: '987654321014')
    expect(page).to have_css('p.dashboard__attribute', text: 'www.treinadev.com.br')
    expect(page).to have_css('p.dashboard__attribute', text: 'www.linkedin.com/in/treinadev')
    expect(page).to have_css('img[src*="ruby.jpeg"]')
    expect(page).not_to have_content('Campus Code')
  end
end