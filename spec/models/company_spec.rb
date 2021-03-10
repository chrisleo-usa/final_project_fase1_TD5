require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'validation' do
    it { should validate_presence_of(:name).on(:edit) }
    it { should validate_presence_of(:address).on(:edit) }
    it { should validate_presence_of(:complement).on(:edit) }
    it { should validate_presence_of(:city).on(:edit) }
    it { should validate_presence_of(:state).on(:edit) }
    it { should validate_presence_of(:site).on(:edit) }
    it { should validate_presence_of(:cnpj).on(:edit) }
    it { should validate_presence_of(:social_media).on(:edit) }
  end
end
