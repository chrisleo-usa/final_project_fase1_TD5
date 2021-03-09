require 'rails_helper'

feature 'Visitor visit' do
  scenario 'companies index' do
    campus = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
      site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
      domain: 'campuscode')
    treinaDev = Company.create!(name: 'Treina Dev', address: 'Rua dos devs, 666', cnpj: 987654321654, 
        site: 'www.treinadev.com', social_media: 'www.linkedin.com/in/treinadev', 
        domain: 'treinadev')

    visit root_path
    click_on 'Empresas'

    expect(current_path).to eq(companies_path)
    expect(Company.count).to eq(2)
    expect(page).to have_content(campus.name)
    expect(page).to have_content(treinaDev.name)
  end

  scenario 'company details' do
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job_js = Job.create!(title: 'Javascript Developer', description: 'Vaga para Javascript Developer', 
                        salary_range: 13000.0, requirements: 'Conhecimento sólido em Javascript, HTML e CSS',
                        deadline_application: '20/08/2022', total_vacancies: 5, level: 2, company: company)
    job_rails = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                            salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                            deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

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
    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job_js = Job.create!(title: 'Javascript Developer', description: 'Vaga para Javascript Developer', 
                        salary_range: 13000, requirements: 'Conhecimento sólido em Javascript, HTML e CSS',
                        deadline_application: '20/08/2022', total_vacancies: 5, level: 1, company: company)

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