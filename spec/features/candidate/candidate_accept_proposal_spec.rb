require 'rails_helper'

feature 'Candidate accept proposal' do
  scenario 'attribute cannot be blank' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)
    proposal = Proposal.create!(proposal_message: 'Congratulations, you have been approved', 
                                proposal_salary: 5000.0, start_date: '10/05/2023', enrollment: enrollment)

    login_as candidate, scope: :candidate
    visit enrollment_path(enrollment)
    click_on 'Proposta'
    click_on 'Aceitar'
    within 'form.create__form' do
      fill_in 'Data de início', with: ''
      click_on 'Enviar'
    end

    expect(current_path).to eq(proposal_accepts_path(proposal))
    expect(Accept.count).to eq(0)
    within('div.warnings') do
      expect(page).to have_content('Data de início não pode ficar em branco')
    end
  end

  scenario 'and cannot see the button to accept or decline proposal' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)
    proposal = Proposal.create!(proposal_message: 'Parabéns, você foi aprovado! Analise sua proposta.', 
                                proposal_salary: 5000.0, start_date: '10/05/2023', enrollment: enrollment, status: :accepted)

    login_as candidate, scope: :candidate
    visit proposal_path(proposal)

    expect(page).not_to have_link('Aceitar')
    expect(page).not_to have_link('Recusar')
  end

  scenario 'sucessfully' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    company = Company.create!(name: 'Campus Code', address: 'Rua São Paulo, 222', cnpj: 1234567891011, 
                              site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                              domain: 'campuscode')

    job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)
    proposal = Proposal.create!(proposal_message: 'Congratulations, you have been approved', 
                                proposal_salary: 5000.0, start_date: '10/05/2023', enrollment: enrollment)

    login_as candidate, scope: :candidate
    visit enrollment_path(enrollment)
    click_on 'Proposta'
    click_on 'Aceitar'
    within 'form.create__form' do
      fill_in 'Data de início', with: '01/03/2021'
      click_on 'Enviar'
    end

    expect(current_path).to eq(proposal_path(proposal))
    expect(page).to have_css('span.dashboard__status', text: 'accepted')
    expect(page).not_to have_css('span.dashboard__status', text: 'pending')
    expect(page).not_to have_css('span.dashboard__status', text: 'declined')
    expect(page).not_to have_link('Decline')
    expect(page).not_to have_link('Accept')
    expect(page).to have_content('Congratulations! Welcome to your new job!')
  end
end