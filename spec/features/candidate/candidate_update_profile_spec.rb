require 'rails_helper'

feature 'Candidate can update his own profile' do
  scenario 'and can access his informations from root_path' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'My profile'

    expect(current_path).to eq(candidate_path(candidate))
  end

  scenario 'see edit button' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit root_path
    click_on 'My profile'

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).to have_link('Edit')
  end

  scenario 'attributes cannot be blank' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
      biography: 'Profissional da área de eventos migrando para a área da tecnologia',
      email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Edit'
    within('form.create__form') do
      fill_in 'Full name', with: ''
      fill_in 'Phone', with: ''
      fill_in 'CPF', with: ''
      fill_in 'Biography', with: ''
      fill_in 'Email', with: ''
      fill_in 'Current password', with: ''
      click_on 'Update'
    end

    expect(current_path).to eq(candidate_registration_path)
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Phone can\'t be blank')
    expect(page).to have_content('Cpf can\'t be blank')
    expect(page).to have_content('Biography can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Current password can\'t be blank')
  end

  scenario 'successfully' do
    candidate = Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910,
                                  biography: 'Profissional da área de eventos migrando para a área da tecnologia',
                                  email: 'chris@campuscode.com', password: '123456')

    login_as candidate, scope: :candidate
    visit candidate_path(candidate)
    click_on 'Edit'
    within('form.create__form') do
      fill_in 'Full name', with: 'Susan Ristau'
      fill_in 'Phone', with: '4891122334455'
      fill_in 'CPF', with: '98765432109'
      fill_in 'Biography', with: 'Promotora de eventos e cerimonialista de casamentos'
      fill_in 'Email', with: 'susan@ristau.com'
      fill_in 'Current password', with: '123456'
      click_on 'Update'
    end

    expect(current_path).to eq(candidate_path(candidate))
    expect(page).not_to have_css('h2.dashboard__name', text: "#{candidate.name} profile")
    expect(page).not_to have_css('p.dashboard__attribute', text: '48988776655')
    expect(page).not_to have_css('p.dashboard__attribute', text: '12345678910')
    expect(page).not_to have_css('p.dashboard__attribute', text: 'Profissional da área de eventos migrando para a área da tecnologia')
    expect(page).not_to have_css('p.dashboard__attribute', text: 'chris@campuscode.com')

    expect(page).to have_css('h2.dashboard__name', text: 'Susan Ristau')
    expect(page).to have_css('p.dashboard__attribute', text: '4891122334455')
    expect(page).to have_css('p.dashboard__attribute', text: '98765432109')
    expect(page).to have_css('p.dashboard__attribute', text: 'Promotora de eventos e cerimonialista de casamentos')
    expect(page).to have_css('p.dashboard__attribute', text: 'susan@ristau.com')
  end
end