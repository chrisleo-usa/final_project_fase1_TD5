require 'rails_helper'

feature 'Visitor visit' do
  scenario 'companies index' do
    campus = create(:company)
    treinaDev = create(:company, name: 'TreinaDev', domain: 'treinadev')

    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq(companies_path)
    expect(Company.count).to eq(2)
    expect(page).to have_content(campus.name)
    expect(page).to have_content(treinaDev.name)
  end

  scenario 'company details' do
    company = create(:company, name: 'Campus Code')
    job_js = create(:job, title: 'Javascript Developer', company: company)
    job_rails = create(:job, title: 'Ruby on Rails Developer', company: company)

    visit root_path
    click_on 'Empresas'
    click_on company.name

    expect(current_path).to eq(company_path(company))
    expect(page).to have_content(company.name)
    expect(page).to have_content(company.address)
    expect(page).to have_content(company.site)
    expect(page).to have_content('Oportunidades de emprego')
    expect(company.jobs.count).to eq(2)
    expect(page).to have_content(job_js.title)
    expect(page).to have_content(job_rails.title)
  end

  scenario 'job details' do
    company = create(:company, name: 'Campus Code')
    job_js = create(:job, title: 'Javascript Developer', salary_range: 13000, level: :junior, company: company)

    visit root_path
    click_on 'Empresas'
    click_on company.name
    click_on job_js.title

    expect(current_path).to eq(company_job_path(company, job_js))
    expect(page).to have_content(job_js.title)
    expect(page).to have_content(job_js.description)
    expect(page).to have_content('13.000,00')
    expect(page).to have_content(job_js.requirements)
    expect(page).to have_content('Júnior')
    expect(page).not_to have_content('Estágio')
    expect(page).not_to have_content('Pleno')
    expect(page).not_to have_content('Senior')
  end
end