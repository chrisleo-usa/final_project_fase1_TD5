require 'rails_helper'

feature 'The visitor applies for a job opportunity' do
  scenario 'but is redirected to sign in' do
    company = create(:company, name: 'Campus Code')
    job = create(:job, title: 'Ruby on Rails Developer', company: company)

    visit root_path
    click_on 'Empresas'
    click_on company.name
    click_on job.title
    click_on 'Aplicar'

    expect(current_path).to eq(new_candidate_session_path)
  end
end
