require 'rails_helper'

feature 'Employee sign up' do
  scenario 'but email already exists' do
    company = create(:company)
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456', company: company)

    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    click_on 'Cadastrar'
    within 'form.create__form' do
      fill_in 'Email', with: employee.email
      fill_in 'Senha', with: employee.password
      fill_in 'Confirmar senha', with: employee.password
      click_on 'Salvar'
    end

    expect(current_path).to eq(employee_registration_path)
    expect(page).to have_content('Não foi possível salvar colaborador: 1 erro')
    expect(page).to have_content('Email já está em uso')
  end

  scenario 'attributes cannot be blank' do
    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    click_on 'Cadastrar'
    within 'form.create__form' do
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirmar senha', with: ''
      click_on 'Salvar'
    end

    expect(current_path).to eq(employee_registration_path)
    expect(page).to have_content('Não foi possível salvar colaborador: 2 erros')
    expect(page).to have_content('Email não pode ficar em branco')
    expect(page).to have_content('Senha não pode ficar em branco')
  end

  scenario 'as admin successfully' do
    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    click_on 'Cadastrar'
    within 'form.create__form' do
      fill_in 'Email', with: 'chris@campuscode.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      click_on 'Salvar'
    end

    expect(current_path).to eq(edit_company_path(Company.last))
    expect(page).to have_content('chris@campuscode.com')
  end

  scenario 'as regular employee successfully' do
    company = create(:company, domain: 'campuscode')

    visit root_path
    click_on 'Login'
    click_on 'Colaborador'
    click_on 'Cadastrar'
    within 'form.create__form' do
      fill_in 'Email', with: 'chris@campuscode.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      click_on 'Salvar'
    end

    employee = Employee.last
    expect(current_path).to eq(company_path(company))
    expect(page).to have_content(employee.email)
  end
end
