require 'rails_helper'

feature 'Candidate decline a proposal' do
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
    click_on 'Proposal'
    click_on 'Decline'
    within 'form.create__form' do
      fill_in 'Reason', with: ''
      click_on 'Send'
    end

    expect(current_path).to eq(proposal_declines_path(proposal))
    expect(Decline.count).to eq(0)
    within('div.warnings') do
      expect(page).to have_content('Reason can\'t be blank')
    end
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
    click_on 'Proposal'
    click_on 'Decline'
    within 'form.create__form' do
      fill_in 'Reason', with: 'I already got a new job'
      click_on 'Send'
    end

    expect(current_path).to eq(proposal_path(proposal))
    expect(page).to have_content('Proposal declined')
    expect(page).to have_content('I already got a new job')
  end
end