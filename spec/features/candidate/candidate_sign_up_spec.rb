require 'rails_helper'

feature 'Candidate sign up' do
  scenario 'successfully' do
    visit root_path
    click_on 'Login'
    click_on 'Candidato'
    click_on 'Cadastrar'
    within('form.create__form') do
      fill_in 'Nome completo', with: 'Christopher Leonardo Alves'
      fill_in 'Telefone', with: '48 988776655'
      fill_in 'CPF', with: '12345678910'
      fill_in 'Biografia', with: 'Profissional da área de eventos migrando para a área da tecnologia'
      fill_in 'Email', with: 'chris@campuscode.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmar senha', with: '123456'
      click_on 'Salvar'
    end

    candidate = Candidate.last
    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_link('Home')
    expect(page).to have_link('Empresas')
    expect(page).to have_link('Inscrições')
    expect(page).to have_css('p.dashboard__attribute', text: candidate.email)
    expect(page).to have_css('p.dashboard__attribute', text: candidate.name)
    expect(page).to have_css('p.dashboard__attribute', text: candidate.phone)
    expect(page).to have_css('p.dashboard__attribute', text: '123.456.789.10')
    expect(page).to have_css('p.dashboard__attribute', text: candidate.biography)
  end

  scenario 'and logout' do
    candidate = create(:candidate)

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Logout'

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Login')
    expect(page).not_to have_content(candidate.email)
    expect(page).not_to have_link('Logout')
  end
end
