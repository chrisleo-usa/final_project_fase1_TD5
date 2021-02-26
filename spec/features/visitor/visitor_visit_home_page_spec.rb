require 'rails_helper'

feature 'A visitor visit home page' do
  scenario 'successfully' do
    visit root_path

    expect(current_path).to eq(root_path)
  end
end