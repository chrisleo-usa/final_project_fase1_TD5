require 'rails_helper'

feature 'Candidate accept proposal' do
  scenario 'attribute cannot be blank' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company)
    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)
    proposal = create(:proposal, enrollment: enrollment)

    login_as candidate, scope: :candidate
    visit enrollment_path(enrollment)
    click_on 'Proposta'
    click_on 'Aceitar'
    within 'form.create__form' do
      fill_in 'Data de início', with: ''
      click_on 'Enviar'
    end

    expect(current_path).to eq(proposal_accepts_path(proposal))
    expect(Accept.count).to eq(0)
    within('div.warnings') do
      expect(page).to have_content('Data de início não pode ficar em branco')
    end
  end

  scenario 'sucessfully' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company)
    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)
    proposal = create(:proposal, enrollment: enrollment)

    login_as candidate, scope: :candidate
    visit enrollment_path(enrollment)
    click_on 'Proposta'
    click_on 'Aceitar'
    within 'form.create__form' do
      fill_in 'Data de início', with: '01/03/2021'
      click_on 'Enviar'
    end

    expect(current_path).to eq(proposal_path(proposal))
    expect(page).to have_css('span.accepted', text: 'Aceita')
    expect(page).not_to have_css('span.pending', text: 'Em análise')
    expect(page).not_to have_css('span.declined', text: 'Recusada')
    expect(page).not_to have_link('Recusar')
    expect(page).not_to have_link('Aceitar')
    expect(page).to have_content('Parabéns, bem vindo a sua nova jornada!')
  end
end