require 'rails_helper'

feature 'Candidate decline a proposal' do
  scenario 'attribute cannot be blank' do
    candidate = create(:candidate)
    company = create(:company)
    job = create(:job, company: company)
    enrollment = Enrollment.create!(job: job, candidate: candidate, status: :approved)
    proposal = create(:proposal, enrollment: enrollment)

    login_as candidate, scope: :candidate
    visit enrollment_path(enrollment)
    click_on 'Proposta'
    click_on 'Recusar'
    within 'form.create__form' do
      fill_in 'Motivo', with: ''
      click_on 'Enviar'
    end

    expect(current_path).to eq(proposal_declines_path(proposal))
    expect(Decline.count).to eq(0)
    within('div.warnings') do
      expect(page).to have_content('Motivo não pode ficar em branco')
      expect(page).to have_content('Motivo é muito curto (mínimo: 10 caracteres)')
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
    click_on 'Recusar'
    within 'form.create__form' do
      fill_in 'Motivo', with: 'Eu já consegui um novo emprego, obrigado'
      click_on 'Enviar'
    end

    expect(current_path).to eq(proposal_path(proposal))
    expect(page).to have_content('Proposta recusada')
    expect(page).to have_content('Eu já consegui um novo emprego, obrigado')
  end
end
