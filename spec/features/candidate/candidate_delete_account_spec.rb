require 'rails_helper'

feature 'Candidate delete account' do
  scenario 'see delete button' do
    candidate =create(:candidate)

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)

    expect(page).to have_link('Deletar')
  end

  scenario 'successfully' do
    candidate = create(:candidate)

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Deletar'

    expect(current_path).to eq(root_path)
    expect(Candidate.count).to eq(0)
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end

  scenario 'even if had a enrollment associated' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company)
    Enrollment.create!(job: job, candidate: candidate)

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Deletar'

    expect(current_path).to eq(root_path)
    expect(Candidate.count).to eq(0)
    expect(Enrollment.count).to eq(0)
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end
end