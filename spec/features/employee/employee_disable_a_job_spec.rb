require 'rails_helper'

feature 'Employee disable a job opportunity' do
  scenario 'and must be signed in' do
    company = create(:company)
    employee = create(:employee, company: company)

    login_as employee, scope: :employee
    visit root_path

    expect(page).not_to have_link('Login')
    expect(page).to have_content(employee.email)
    expect(page).to have_link('Logout')
  end

  scenario ', if job is already disabled, employee cannot see the button to disable again' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, company: company, status: :inactive)

    login_as employee, scope: :employee
    visit company_job_path(company, job)

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_link('Inativar')
  end

  scenario 'and employee from another company, cannot see the button to disable job' do
    company = create(:company)
    employee = create(:employee, company: company)
    other_company = Company.create!(name: 'Portal Solar', address: 'Rua da portal', complement: '897, sala 50',
                                    city: 'São Paulo', state: 'SP', cnpj: 98765432101011,
                                    site: 'www.portalsolar.com.br', social_media: 'www.linkedin.com/in/campuscode',
                                    domain: 'campuscode')
    other_employee = create(:employee, email: 'joao@portalsolar.com', company: other_company)
    job = create(:job, company: company)

    login_as other_employee, scope: :employee
    visit company_job_path(company, job)

    expect(current_path).to eq(company_job_path(company, job))
    expect(page).not_to have_link('Inativar')
  end

  scenario 'successfully' do
    company = create(:company)
    employee = create(:employee, company: company)
    job = create(:job, title: 'Ruby on Rails Developer', company: company)

    login_as employee, scope: :employee
    visit root_path
    click_on 'Minha empresa'
    click_on job.title
    click_on 'Inativar'

    job.reload
    expect(page).to have_content("#{job.title} - Inativa")
    expect(job).to be_inactive
  end
end