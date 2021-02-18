require 'rails_helper'

feature 'Employee sign up' do
  scenario 'but email already exists' do
    employee = Employee.create!(email: 'chris@campuscode.com', password: '123456')

    visit root_path
    click_on 'Login'
    click_on 'Employee'
    click_on 'Sign up'
    within('form') do
      fill_in 'Email', with: employee.email
      fill_in 'Password', with: employee.password
      fill_in 'Password confirmation', with: employee.password
      click_on 'Sign up'
    end

    expect(current_path).to eq(employee_registration_path)
    expect(page).not_to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content('1 error prohibited this employee from being saved:')
    expect(page).to have_content('Email has already been taken')
  end

  scenario 'attributes cannot be blank' do
    visit root_path
    click_on 'Login'
    click_on 'Employee'
    click_on 'Sign up'
    within('form') do
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      click_on 'Sign up'
    end

    expect(current_path).to eq(employee_registration_path)
    expect(page).not_to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content('2 errors prohibited this employee from being saved:')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
  end

  scenario 'successfully' do
    visit root_path
    click_on 'Login'
    click_on 'Employee'
    click_on 'Sign up'
    within('form') do
      fill_in 'Email', with: 'chris@campuscode.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'
    end

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content('chris@campuscode.com')
  end
end