# frozen_string_literal: true

require 'rails_helper'

feature 'User can see gist content', %(
  In order to take info from question/answer links
  As a user
  I'd like to be able to see gist content without following a link
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }
  given(:gist_url) { 'https://gist.github.com/bl1ndy/b5d79c9d5e7a312edd5fb27c67f69b68' }

  describe 'After Question page load' do
    background do
      question.links.create(title: 'My gist', url: gist_url)

      visit question_path(question)
    end

    scenario 'User sees gist content on question link' do
      within '.question' do
        expect(page).to have_content('mocked test gist')
      end
    end
  end

  describe 'On Question page' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User sees gist content on question link after update question' do
      within '.question' do
        click_link('Edit')
        click_link('Add link')

        within '#question-links' do
          fill_in(placeholder: 'title', with: 'My gist')
          fill_in(placeholder: 'url', with: gist_url)
        end

        click_button('Save')

        expect(page).to have_content('mocked test gist')
      end
    end

    scenario 'User sees gist content on answer link after create answer' do
      within '.new-answer' do
        fill_in('Text', with: 'My Answer')
        fill_in(placeholder: 'title', with: 'My gist')
        fill_in(placeholder: 'url', with: gist_url)

        click_button('Post Your Answer')
      end

      within '.answers' do
        expect(page).to have_content('mocked test gist')
      end
    end

    scenario 'User sees info message if gist not found' do
      within '.question' do
        click_link('Edit')
        click_link('Add link')

        within '#question-links' do
          fill_in(placeholder: 'title', with: 'My gist')
          fill_in(placeholder: 'url', with: 'https://gist.github.com/bl1ndy/b5d79c9d5e7a')
        end

        click_button('Save')

        expect(page).to have_content('Gist not found')
      end
    end
  end
end
