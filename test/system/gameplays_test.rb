require 'application_system_test_case'

class GameplaysTest < ApplicationSystemTestCase
  test 'play the game' do
    @white = users(:one)
    @black = users(:two)

    Capybara.using_session('white') do
      visit new_user_session_url
      fill_in 'Email', with: @white.email
      fill_in 'Password', with: 'asecret'
      click_on 'Log in'
      assert_content "Logout #{@white.email}"
    end

    Capybara.using_session('black') do
      visit new_user_session_url
      fill_in 'Email', with: @black.email
      fill_in 'Password', with: 'asecret'
      click_on 'Log in'
      assert_content "Logout #{@black.email}"
    end

    Capybara.using_session('white') do
      visit games_url
      click_on 'Start New Game'
      assert_content "I am user #{@white.id}"
      assert_content 'Waiting for second player'
      @url = current_url
    end

    @game_id = @url[/\d+$/].to_i
    @game = Game.find(@game_id)
    @game.update(word: 'abba', mask: '____')

    Capybara.using_session('black') do
      visit @url
      assert_content "Game #{@game_id}"
      assert_content "I am user #{@black.id}"
      assert_content 'Waiting for second player'
      click_on 'Join this Game'
      assert_content "User #{@black.id} is Player Black" 
      click_on 'a' 
      assert_content "a__a"
      click_on 'x'
      assert_content "a__a"
    end

    Capybara.using_session('white') do
      visit @url
      assert_content "I am user #{@white.id}"
      assert_content "User #{@white.id} is Player White" 
      click_on 'b'
      save_and_open_page
      assert_content "abba"
      assert_content "User #{@white.id} is Player White has won"
    end
  end
end
