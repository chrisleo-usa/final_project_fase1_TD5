require 'rails_helper'

feature 'Candidate can update his own profile' do
  scenario 'and access his profile from root_path' do
    candidate = create(:candidate)

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'Perfil'

    expect(current_path).to eq(candidate_path(candidate))
  end

  scenario 'see edit button' do
    candidate = create(:candidate)

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'Perfil'

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_link('Editar')
  end

  scenario 'attributes cannot be blank' do
    candidate = create(:candidate)

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Edit'
    within('form.create__form') do
      fill_in 'Nome completo', with: ''
      fill_in 'Telefone', with: ''
      fill_in 'CPF', with: ''
      fill_in 'Biografia', with: ''
      fill_in 'Email', with: ''
      fill_in 'Senha atual', with: ''
      click_on 'Salvar'
    end

    expect(current_path).to eq(candidate_registration_path)
    expect(page).to have_content('Nome completo não pode ficar em branco')
    expect(page).to have_content('Telefone não pode ficar em branco')
    expect(page).to have_content('Email não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to have_content('Biografia não pode ficar em branco')
  end

  scenario 'successfully' do
    candidate = create(:candidate, name: 'Christopher Alves')

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Edit'
    within('form.create__form') do
      fill_in 'Nome completo', with: 'Susan Ristau'
      fill_in 'Telefone', with: '48911223344'
      fill_in 'CPF', with: '98765432109'
      fill_in 'Biografia', with: 'Promotora de eventos e cerimonialista de casamentos'
      fill_in 'Email', with: 'susan@ristau.com'
      fill_in 'Senha atual', with: '123456'
      click_on 'Salvar'
    end

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).not_to have_css('h2.dashboard__title', text: "Christopher Alves profile")
    expect(page).not_to have_css('p.dashboard__attribute', text: '48988776655')
    expect(page).not_to have_css('p.dashboard__attribute', text: '12345678910')
    expect(page).not_to have_css('p.dashboard__attribute', text: 'Profissional da área de eventos migrando para a área da tecnologia')
    expect(page).not_to have_css('p.dashboard__attribute', text: 'chris@campuscode.com')

    expect(page).to have_css('h2.dashboard__title', text: 'Susan Ristau')
    expect(page).to have_css('p.dashboard__attribute', text: '(48) 91122-3344')
    expect(page).to have_css('p.dashboard__attribute', text: '987.654.321.09')
    expect(page).to have_css('p.dashboard__attribute', text: 'Promotora de eventos e cerimonialista de casamentos')
    expect(page).to have_css('p.dashboard__attribute', text: 'susan@ristau.com')
  end
end