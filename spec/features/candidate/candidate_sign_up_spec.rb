require 'rails_helper'

feature 'Visitor sign up as candidate' do
  scenario 'successfully' do
    visit root_path
    click_on 'Login'
    click_on 'Candidate'
    click_on 'Sign up'
    within('form') do
      fill_in 'Full name', with: 'Christopher Leonardo Alves'
      fill_in 'Phone', with: '48 988776655'
      fill_in 'CPF', with: '12345678910'
      fill_in 'Biography', with: 'Profissional da área de eventos migrando para a área da tecnologia'
      fill_in 'Email', with: 'chris@campuscode.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
    end

    candidate = Candidate.last
    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_link('Home')
    expect(page).to have_link('Companies')
    expect(page).to have_link('My applications')
    expect(page).to have_content(candidate.email)
    expect(page).to have_content(candidate.name)
    expect(page).to have_content(candidate.phone)
    expect(page).to have_content(candidate.cpf)
    expect(page).to have_content(candidate.biography)
  end

  scenario 'and logout' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, biography: 'Profissional da área de eventos migrando para a área da tecnologia', email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Logout'

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Login')
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end
end