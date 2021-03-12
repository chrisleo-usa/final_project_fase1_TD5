require 'rails_helper'

RSpec.describe Candidate, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      candidate = Candidate.new

      expect(candidate.valid?).to eq(false)
      expect(candidate.errors.count).to eq(6)
    end

    it 'email must be unique' do
      create(:candidate, email: 'chris@campuscode.com.br')

      candidate = Candidate.new(email: 'chris@campuscode.com.br')

      expect(candidate.valid?).to eq(false)
      expect(candidate.errors[:email]).to include('já está em uso')
    end

    it 'create a valid candidate' do
      candidate = create(:candidate)

      expect(candidate).to be_valid
    end
  end

  context 'Delete #destroy' do
    it 'delete account' do
      candidate = create(:candidate)

      Candidate.destroy(candidate.id)

      expect(Candidate.count).to eq(0)
    end

    it 'delete account and enrollment associated' do
      candidate = create(:candidate)
      company = create(:company)
      job = create(:job, company: company)
      Enrollment.create!(job: job, candidate: candidate)

      Candidate.destroy(candidate.id)

      expect(Candidate.count).to eq(0)
      expect(Enrollment.count).to eq(0)
      expect(Job.count).to eq(1)
      expect(Company.count).to eq(1)
    end
  end
end
