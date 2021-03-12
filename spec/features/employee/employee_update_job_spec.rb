require 'rails_helper'

feature 'Employee update job' do
  scenario 'but need be signed in to see edit button' do
    company = create(:company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)

    visit root_path
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_css('h2.dashboard__title', text: job.title)
    expect(page).to have_link('Login')
    expect(page).not_to have_link('Editar')
  end

  scenario 'but attributes cannot be blank' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title
    click_on 'Editar'
    within 'form.create__form' do
      fill_in 'Título', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Média salarial', with: ''
      fill_in 'Requerimentos', with: ''
      fill_in 'Data limite para aplicar', with: ''
      fill_in 'Total de vagas', with: ''
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Média salarial não pode ficar em branco')
    expect(page).to have_content('Requerimentos não pode ficar em branco')
    expect(page).to have_content('Data limite para aplicar não pode ficar em branco')
    expect(page).to have_content('Total de vagas não pode ficar em branco')
  end

  scenario 'successfully' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title
    click_on 'Editar'
    within 'form.create__form' do
      fill_in 'Título', with: 'Desenvolvedor Front-End'
      fill_in 'Descrição', with: 'Vaga de emprego para Desenvolvedor Front-End'
      fill_in 'Média salarial', with: 7000
      select 'Clt pj', from: 'Contratação'
      select 'Senior', from: 'Nível'
      fill_in 'Requerimentos', with: 'Conhecimento sólido em Javascript, CSS, HTML, Bootstrap, Gulp e React'
      fill_in 'Data limite para aplicar', with: '25/10/2023'
      fill_in 'Total de vagas', with: 10
      click_on 'Salvar'
    end

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_content('Ruby on Rails Developer')
    expect(page).not_to have_content('Vaga para Ruby on Rails Developer')
    expect(page).not_to have_content('9.000,00')
    expect(page).not_to have_content('Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite')
    expect(page).not_to have_content('10/04/2023')
    expect(page).not_to have_content('Júnior')
    expect(page).not_to have_content('Pleno')
    expect(page).not_to have_content('Estágio')

    expect(page).to have_content('Desenvolvedor Front-End')
    expect(page).to have_content('Vaga de emprego para Desenvolvedor Front-End')
    expect(page).to have_content('7.000,00')
    expect(page).to have_content('CLT/PJ')
    expect(page).to have_content('Conhecimento sólido em Javascript, CSS, HTML, Bootstrap, Gulp e React')
    expect(page).to have_content('25/10/2023')
    expect(page).to have_content('Senior')
  end
end