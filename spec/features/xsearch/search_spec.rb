# frozen_string_literal: true

require 'sphinx_helper'

SCOPES = %w[User Question Answer Comment].freeze

feature 'User can search for users/questions/answers/comments', %(
  In order to find needed information
  As a user
  I'd like to be able to search for any app entities
), js: true do
  given!(:user) { create(:user, email: 'test@test.com') }
  given!(:question) { create(:question, title: 'Test Question', user:) }
  given!(:answer) { create(:answer, body: 'Test Answer', question:, user:) }
  given!(:comment) { create(:comment, body: 'Test Comment', commentable: answer, user:) }

  background { visit questions_path }

  # rubocop:disable RSpec/MultipleExpectations
  scenario 'User searches in All scope', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in(placeholder: 'Search for:', with: 'test')
      select 'All', from: :scope
      click_button 'Search'

      expect(page).to have_content(user.email)
      expect(page).to have_content(question.title)
      expect(page).to have_content(answer.body)
      expect(page).to have_content(comment.body)
    end
  end
  # rubocop:enable RSpec/MultipleExpectations

  SCOPES.each do |scope|
    scenario "User searches in #{scope}s scope", sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in(placeholder: 'Search for:', with: 'test')
        select scope, from: :scope
        click_button 'Search'

        content = scope == 'User' ? user.email : "Test #{scope}"
        expect(page).to have_content(content)
        expect(page).to have_css('.search-result', count: 1)
      end
    end
  end

  scenario 'User founds nothing', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in(placeholder: 'Search for:', with: 'qwertyuiop')
      select 'All', from: :scope
      click_button 'Search'

      expect(page).to have_content('Nothing found')
    end
  end

  scenario 'User tries to search without query', sphinx: true do
    ThinkingSphinx::Test.run do
      click_button 'Search'

      expect(page).to have_content('Nothing found')
    end
  end
end
