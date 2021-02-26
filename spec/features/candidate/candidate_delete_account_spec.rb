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
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end
end