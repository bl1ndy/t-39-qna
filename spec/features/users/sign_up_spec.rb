# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up.', %(
  In order to use all site functional
  As a guest
  I'd like to be able to sign up
) do
  given!(:user) { User.create(email: 'old_user@test.com', password: '87654321') }

  background { visit new_user_registration_path }

  scenario 'Guest tries to sign up' do
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'Guest tries to sign up with errors' do
    click_button 'Sign up'

    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  scenario 'Registered user tries to sign up with the same email' do
    fill_in 'Email', with: 'old_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end
end
