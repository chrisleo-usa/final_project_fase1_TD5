require 'rails_helper'

feature 'Employee admin register a job opportunity' do
  scenario 'and must be signed in' do
    company = create(:company)
    employee = create(:employee, email: 'chris@campuscode.com', company: company)

    login_as employee, scope: :employee

    visit root_path

    expect(page).not_to have_link('Login')
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end

  scenario ', regular employee cannot register a job opportunity' do
    company = create(:company)
    employee = create(:employee, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'

    expect(current_path).to eq(company_path(company))
    expect(page).not_to have_link('Register a job opportunity')
  end

  scenario 'attributes cannot be blank' do
    company = create(:company)
    employee = create(:employee, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on 'Registrar novo emprego'
    within 'form.create__form' do
      fill_in 'Título', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Média salarial', with: ''
      select 'Nível da vaga', from: 'Nível'
      fill_in 'Requerimentos', with: ''
      fill_in 'Data limite para aplicar', with: ''
      fill_in 'Total de vagas', with: ''
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_jobs_path(company))
    within('div.warnings') do
      expect(page).to have_content('Título não pode ficar em branco')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Média salarial não pode ficar em branco')
      expect(page).to have_content('Nível não pode ficar em branco')
      expect(page).to have_content('Requerimentos não pode ficar em branco')
      expect(page).to have_content('Data limite para aplicar não pode ficar em branco')
      expect(page).to have_content('Total de vagas não pode ficar em branco')
    end
  end

  scenario 'successfully' do
    company = create(:company)
    employee = create(:employee, company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on 'Registrar novo emprego'
    within 'form.create__form' do
      fill_in 'Título', with: 'Dev Front-End'
      fill_in 'Descrição', with: 'Vaga para desenvolvedor Front End'
      fill_in 'Média salarial', with: 5000
      select 'Clt', from: 'Contratação'
      select 'Intern', from: 'Nível'
      fill_in 'Requerimentos', with: 'Necessário Javascript, React, Rails, Php, Python, Java e etc...'
      fill_in 'Data limite para aplicar', with: '20/01/2050'
      fill_in 'Total de vagas', with: 5
      click_on 'Salvar'
    end
    click_on 'Dev Front-End'

    job = Job.last
    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_content('Dev Front-End')
    expect(page).to have_content('Vaga para desenvolvedor Front End')
    expect(page).to have_content('5.000,00')
    expect(page).to have_content('Necessário Javascript, React, Rails, Php, Python, Java e etc...')
    expect(page).to have_content('20/01/2050')
    expect(page).to have_content('Estágio')
    expect(page).to have_content('CLT')
    expect(page).not_to have_content('Júnior')
    expect(page).not_to have_content('Pleno')
    expect(page).not_to have_content('Senior')
  end
end
