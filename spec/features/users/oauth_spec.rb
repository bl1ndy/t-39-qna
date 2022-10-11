# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in via OAuth', %(
  In order to more comfortable signing in/signing up
  As a guest or registered user
  I'd like to be able to sign up/sign in via OAuth
) do
  OmniAuth.config.test_mode = true

  background do
    OmniAuth.config.mock_auth.delete(:github)
    OmniAuth.config.mock_auth.delete(:vkontakte)
    visit new_user_session_path
  end

  scenario 'User tries to sign in via Github' do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github', uid: '123456', info: { email: 'mocked@user.com' }
    )
    click_link('Sign in with GitHub')

    expect(page).to have_content('Successfully authenticated from Github account.')
  end

  scenario 'User tries to sign in via Github with invalid credentials' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_link('Sign in with GitHub')

    expect(page).to have_content('Could not authenticate you from GitHub')
  end

  scenario 'User tries to sign in via VK without email access' do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456')
    click_link('Sign in with Vkontakte')
    expect(page).to have_content 'Email confirmation'

    fill_in 'Email', with: 'oauth@test.com'
    click_button 'Send confirmation link'

    open_email('oauth@test.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content('Your email address has been successfully confirmed')

    click_link('Sign in with Vkontakte')
    expect(page).to have_content('Successfully authenticated from VK account.')
  end

  scenario 'User tries to sign in via VK with invalid credentials' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    click_link('Sign in with Vkontakte')

    expect(page).to have_content('Could not authenticate you from Vkontakte')
  end
end
