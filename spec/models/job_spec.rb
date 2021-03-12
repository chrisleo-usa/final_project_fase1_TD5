require 'rails_helper'

RSpec.describe Job, type: :model do
  context 'validation' do
    it 'attributes cannot be blank' do
      create(:company)

      job = Job.new

      expect(job.valid?).to eq(false)
      expect(job.errors.count).to eq(8)
    end

    it 'create a valid job' do
      company = create(:company)
      job = create(:job, company: company)

      expect(job).to be_valid
    end
  end

  context 'Job status' do
    it 'by default is 0 (active)' do
      company = create(:company)
      job = Job.create!(title: 'Ruby on Rails Developer', description: 'Vaga para Ruby on Rails Developer',
                        salary_range: 9000.0, requirements: 'Conhecimento sólido em Java, '\
                        'Ruby, Ruby on Rails, NodeJS, SQLite3',
                        deadline_application: '10/04/2023', total_vacancies: 2, level: 1, company: company)

      expect(job.status).to eq('active')
    end

    it 'is inactive when a company employee disables' do
      company = create(:company)
      job = create(:job, company: company)

      job.inactive!

      job.reload
      expect(job.status).to eq('inactive')
    end
  end
end
