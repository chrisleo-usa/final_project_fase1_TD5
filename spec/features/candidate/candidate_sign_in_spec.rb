require 'rails_helper'

feature 'Candidate sign in' do
  scenario 'attributes cannot be blank' do
    visit root_path
    click_on 'Login'
    click_on 'Candidato'
    within('form.log_in__form') do
      fill_in 'Email', with: ''
      fill_in 'Senha', with: ''
      click_on 'Entrar'
    end

    expect(current_path).to eq(new_candidate_session_path)
    expect(page).to have_content('Email ou senha inválidos')
  end

  scenario 'Successfully' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                  email: 'chris@campuscode.com', password: '123456')

    visit root_path
    click_on 'Login'
    click_on 'Candidato'
    within('form.log_in__form') do
      fill_in 'Email', with: candidate.email
      fill_in 'Senha', with: candidate.password
      click_on 'Entrar'
    end

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_css('h2.dashboard__title', text: candidate.name)
  end

  scenario 'and Logout' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Logout'

    expect(current_path).to eq(root_path)
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end
end