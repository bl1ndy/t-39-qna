# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for other answers', %(
  In order to give info about useful/unuseful answers
  As an authenticated user
  I'd like to be able to vote for answers
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }
  given!(:another_answer) { create(:answer, question:, user: create(:user)) }

  describe "Answer's author" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can not vote for his answer' do
      within "#answer-#{answer.id}" do
        click_button(class: 'vote-up')
      end

      expect(page).to have_content("You can't vote for your own post")
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can upvote for answer' do
      within "#answer-#{another_answer.id}" do
        click_button(class: 'vote-up')

        within '.rating' do
          expect(page).to have_content('1')
        end
      end
    end

    scenario 'can cancel own vote' do
      within "#answer-#{another_answer.id}" do
        click_button(class: 'vote-up')
        click_button(class: 'vote-up-cancel')

        within '.rating' do
          expect(page).to have_content('0')
        end
      end
    end

    scenario 'can downvote for answer' do
      within "#answer-#{another_answer.id}" do
        click_button(class: 'vote-down')

        within '.rating' do
          expect(page).to have_content('-1')
        end
      end
    end

    scenario 'can not vote more than 1 time for current answer' do
      within "#answer-#{another_answer.id}" do
        click_button(class: 'vote-up')
        click_button(class: 'vote-down')
      end

      expect(page).to have_content('You have already voted for this post')
    end
  end

  describe 'Not authenticated user' do
    before { visit question_path(question) }

    scenario 'does not see vote buttons' do
      within "#answer-#{answer.id}" do
        expect(page).to have_no_button(class: 'vote-up')
        expect(page).to have_no_button(class: 'vote-down')
      end
    end
  end
end
