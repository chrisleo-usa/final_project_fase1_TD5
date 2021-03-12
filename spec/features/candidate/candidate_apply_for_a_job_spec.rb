require 'rails_helper'

feature 'Candidate apply for a job' do
  scenario 'must be signed in' do
    company = create(:company, name: 'Campus Code')
    job = create(:job, title: 'Ruby on Rails Developer', company: company)

    visit root_path
    click_on 'Empresas'
    click_on company.name
    click_on job.title
    click_on 'Aplicar'

    expect(current_path). to eq(new_candidate_session_path)
  end

  scenario 'successfully and is redirect to enrollments page' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company)

    login_as candidate, scope: :candidate
    visit company_job_path(company, job)
    click_on 'Aplicar'

    expect(current_path).to eq(candidate_enrollments_path(candidate))
    expect(page).to have_content('Inscrição realizada com sucesso!')
    within('div.index__list') do
      expect(page).to have_link(job.title)
      expect(page).to have_link(company.name)
      expect(page).to have_css('p.index__card__attribute', text: 'Em análise')
    end
  end

  scenario 'cannot apply again for the same job' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company)
    Enrollment.create!(job: job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit company_job_path(company, job)
    click_on 'Aplicar'

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_content('Você já se inscreveu para esta vaga!')
  end

  scenario 'cannot see apply button if job status is inactive' do 
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company, status: :inactive)

    login_as candidate, scope: :candidate
    visit company_job_path(company, job)

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_link('Aplicar')
  end

  scenario 'and sees enrollment job page' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)
    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit candidate_enrollments_path(candidate)
    click_on job.title

    expect(current_path).to eq(enrollment_path(enrollment))
  end
end
