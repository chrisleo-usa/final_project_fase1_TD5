require 'rails_helper'

feature 'The visitor applies for a job opportunity' do
  scenario 'but is redirected to sign in' do
    company = Company.create!(name: 'Treinadev', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')
    job = Job.create!(title: 'Javascript Developer', description: 'Vaga para Javascript Developer', 
                        salary_range: 13000.0, requirements: 'Conhecimento sólido em Javascript, HTML e CSS',
                        deadline_application: '20/08/2022', total_vacancies: 5, level: 1, company: company)

    visit root_path
    click_on 'Companies'
    click_on company.name
    click_on job.title
    click_on 'Apply'

    expect(current_path).to eq(new_candidate_session_path)
  end
end