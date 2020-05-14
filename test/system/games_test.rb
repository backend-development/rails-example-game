require 'application_system_test_case'

class GamesTest < ApplicationSystemTestCase
  setup do
    @game = games(:one)
  end

  test 'visiting the index' do
    visit games_url
    assert_selector 'h1', text: 'Word Guesser'
    assert_selector 'h2', text: 'Available'
  end

  test 'creating a Game is not possible without login' do
    visit games_url
    refute_content 'Start New Game'
  end

  test 'creating a Game is possible with login' do
    visit new_user_session_path
    fill_in 'Email', with: 'one@example.com'
    fill_in 'Password', with: 'asecret'
    click_on 'Log in'
    visit games_url
    click_on 'Start New Game'
    assert_content 'I am user'
    assert_content 'Waiting for second player'
  end
end
