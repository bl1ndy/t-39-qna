# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for other questions', %(
  In order to give info about useful/unuseful questions
  As an authenticated user
  I'd like to be able to vote for questions
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }
  given(:another_question) { create(:question, user: create(:user)) }

  before { sign_in(user) }

  describe "Question's author" do
    before { visit question_path(question) }

    scenario 'can not vote for his question' do
      within '.question' do
        click_button(class: 'vote-up')
      end

      expect(page).to have_content("You can't vote for your own post")
    end
  end

  describe 'Authenticated user' do
    before { visit question_path(another_question) }

    scenario 'can upvote up for question' do
      within '.question' do
        click_button(class: 'vote-up')

        within '.rating' do
          expect(page).to have_css('.upvoted')
          expect(page).to have_content('+1')
        end
      end
    end

    scenario 'can downvote for question' do
      within '.question' do
        click_button(class: 'vote-down')

        within '.rating' do
          expect(page).to have_css('.downvoted')
          expect(page).to have_content('-1')
        end
      end
    end
  end
end
