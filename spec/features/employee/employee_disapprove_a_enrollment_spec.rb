require 'rails_helper'

feature 'A employee disapprove a enrollment' do
  scenario 'can see deny button' do
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
    expect(page).to have_link('Reprovar')
  end

  scenario 'but cannot see the deny button if enrollment is already disapproved' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, company: company)
    candidate = create(:candidate)
    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :denied)
    create(:reject, enrollment: enrollment)

    login_as employee, scope: :employee
    visit enrollment_path(enrollment)

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).not_to have_link('Reprovar')
  end

  scenario 'see form to fill with disapproval message' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, company: company)
    candidate = create(:candidate)
    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit enrollment_path(enrollment)
    click_on 'Reprovar'

    expect(current_path).to eq(new_enrollment_reject_path(enrollment))
    expect(page).to have_css('form.create__form')
  end

  scenario 'successfully' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, company: company)
    candidate = create(:candidate)
    enrollment = Enrollment.create!(job: job, candidate: candidate)

    login_as employee, scope: :employee
    visit enrollment_path(enrollment)
    click_on 'Reprovar'
    within 'form.create__form' do
      fill_in 'Motivo da reprovação', with: 'Agradecemos o seu interesse em nossa empresa, mas no momento estamos procurando alguém com mais experiência.'
      click_on 'Enviar'
    end

    expect(current_path).to eq(enrollment_path(enrollment))
    expect(page).to have_content('Agradecemos o seu interesse em nossa empresa, mas no momento estamos procurando alguém com mais experiência.')
  end
end