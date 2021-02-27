require 'rails_helper'

feature 'Candidate delete account' do
  scenario 'must be signed in' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@campuscode.com', password: '123456')

    visit root_path
    click_on 'Login'
    click_on 'Candidate'
    within('form') do
      fill_in 'Email', with: candidate.email
      fill_in 'Password', with: candidate.password
      click_on 'Log in'
    end

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_content(candidate.name)
  end

  scenario 'successfully' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
      biography: 'Profissional da área de eventos migrando para a área da tecnologia',
      email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'My profile'
    click_on 'Delete'

    expect(current_path).to eq(root_path)
    expect(Candidate.count).to eq(0)
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end

  scenario 'even if had a enrollment associated' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
      biography: 'Profissional da área de eventos migrando para a área da tecnologia',
      email: 'chris@campuscode.com', password: '123456')

    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    Enrollment.create!(job: job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'My profile'
    click_on 'Delete'

    expect(current_path).to eq(root_path)
    expect(Candidate.count).to eq(0)
    expect(Enrollment.count).to eq(0)
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end
end