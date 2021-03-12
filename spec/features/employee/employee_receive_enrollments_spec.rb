require 'rails_helper'

feature 'Employee can see enrollments' do
  scenario 'but cannot see enrollments if is not signed in' do
    company = create(:company, name: 'Campus Code')
    job = create(:job, title: "Ruby on Rails Developer", company: company)
    candidate = create(:candidate, name: 'Christopher Alves')
    enrollment = Enrollment.create!(job: job, candidate: candidate)

    visit root_path
    click_on 'Empresas'
    click_on company.name
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_link(candidate.name)
  end

  scenario 'but there is none' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)
    candidate = create(:candidate, name: 'Christopher Alves')

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_content('Sem inscrições no momento')
  end

  scenario 'successfully' do
    company = create(:company)
    employee = create(:employee, admin: 1, company: company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)
    candidate = create(:candidate, name: 'Christopher Alves')
    other_candidate = create(:candidate, name: 'Susan', email: 'susan@gmail.com')
    enrollment = Enrollment.create!(job: job, candidate: candidate)
    another_enrollment = Enrollment.create!(job: job, candidate: other_candidate)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).to have_content('Inscrições recebidas:')
    expect(page).to have_link(candidate.name)
    expect(page).to have_link(other_candidate.name)
  end

  scenario 'and view enrollment details' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)
    candidate = create(:candidate, name: 'Christopher Alves')
    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title
    click_on candidate.name

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_css('h2.dashboard__title', text: "Inscrição")
    within('div.dashboard__grid') do
      expect(page).to have_css('p.dashboard__attribute', text: candidate.name)
      expect(page).to have_css('p.dashboard__attribute', text: candidate.email)
      expect(page).to have_css('p.dashboard__attribute', text: '(48) 98877-6655')
      expect(page).to have_css('p.dashboard__attribute', text: candidate.biography)

      expect(page).to have_css('p.dashboard__attribute', text: job.title)
      expect(page).to have_css('p.dashboard__attribute', text: job.description)
      expect(page).to have_css('p.dashboard__attribute', text: 'Júnior')
      expect(page).to have_css('p.dashboard__attribute', text: '9.000,00')
      expect(page).to have_css('p.dashboard__attribute', text: job.requirements)
    end
  end

  scenario 'regular employees can see enrollment details' do
    company = create(:company)
    employee = create(:employee, admin: 0,company: company)
    job = create(:job, company: company)
    candidate = create(:candidate, name: 'Christopher Alves')
    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit company_job_path(company, job)
    click_on candidate.name

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_css('h2.dashboard__title', text: "Inscrição")
    within('div.dashboard__grid') do
      expect(page).to have_css('p.dashboard__attribute', text: candidate.name)
      expect(page).to have_css('p.dashboard__attribute', text: candidate.email)
      expect(page).to have_css('p.dashboard__attribute', text: '(48) 98877-6655')
      expect(page).to have_css('p.dashboard__attribute', text: candidate.biography)

      expect(page).to have_css('p.dashboard__attribute', text: job.title)
      expect(page).to have_css('p.dashboard__attribute', text: job.description)
      expect(page).to have_css('p.dashboard__attribute', text: 'Júnior')
      expect(page).to have_css('p.dashboard__attribute', text: '9.000,00')
      expect(page).to have_css('p.dashboard__attribute', text: job.requirements)
    end
  end
end