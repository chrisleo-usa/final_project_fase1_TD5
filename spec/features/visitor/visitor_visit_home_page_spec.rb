require 'rails_helper'

feature 'A visitor visit home page' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_content('Welcome, take a look at these job openings!')
  end
end