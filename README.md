# Creating a basic hangman game


## new rails

    rails new  --webpack --skip-sprockets  -d postgresql --skip-spring --skip-turbolinks hangman

## first model: vocabulry with words


    $ rails generate model vocabulary word

      invoke  active_record
      create    db/migrate/20200512175829_create_vocabularies.rb
      create    app/models/vocabulary.rb
      invoke    test_unit
      create      test/models/vocabulary_test.rb
      create      test/fixtures/vocabularies.yml    


oops, I did not want a table "vocabularies".  let's roll this generator back


    $ rails destroy model vocabulary word
          invoke  active_record
          remove    db/migrate/20200512175829_create_vocabularies.rb
          remove    app/models/vocabulary.rb
          invoke    test_unit
          remove      test/models/vocabulary_test.rb
          remove      test/fixtures/vocabularies.yml


in file config/initializers/inflections.rb we can add an irregular plural:

    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.uncountable ['sheep', 'vocabulary']
    end

    $ rails generate model vocabulary word
          invoke  active_record
          create    db/migrate/20200512180416_create_vocabulary.rb
          create    app/models/vocabulary.rb
          invoke    test_unit
          create      test/models/vocabulary_test.rb
          create      test/fixtures/vocabulary.yml  

time to add some seeds and fixtures:

    # seeds.rb
    Vocabulary.create(word: 'javascript')
    Vocabulary.create(word: 'internet')
    Vocabulary.create(word: 'refactoring')

    # vocabulary.yml
    one:
      word: javascript

    two:
      word: internet

    three:
      word: refactoring


## start the database


    createdb hangman_development
    createdb hangman_test
    rails db:migrate


## users

    rails g controller static home
    bundle add devise
    rails g devise:install
    rails g devise User

## guest user

    bundle add  devise-guests
    rails g devise_guests User
    rails db:migrate

now every visitor is assigned a guest user automatically
even before signing in:

      <% if user_signed_in? %>
        <%= link_to "Users", users_path %>
        <%= link_to "Logout #{current_user}", logout_path %>
      <% else %>
        <%= link_to "Register", new_user_registration_path %>
        <%= link_to "Login", new_user_session_path %>
        You are a guest user <%= guest_user %>
      <% end %>


## game, game_state and the gem "acts as state machine" aasm

See https://github.com/aasm/aasm

    bundle add aasm
    rails g scaffold game game_state word closed_at:timestamp

    create_table :games do |t|
      t.string :game_state
      t.string :word
      t.timestamp :closed_at
      t.timestamps
    end    

implement the game logic using TDD, starting with these tests:

    test "game can be created by user" do
      u = users(:one)

      g = Game.start(user: u)
      assert_equal g.players.count, 1
      assert_equal g.players.find_by(color: 'white').user_id, u.id
      assert g.lobby?
    end

    test "2nd player can join a game in lobby-state" do
      u1 = users(:one)
      u2 = users(:two)
      g = Game.start(user: u1)
      g.join(u2)

      assert_equal g.players.count, 2
      assert_equal g.players.find_by(color: 'black').user_id, u2.id
      assert_nil g.closed_at
      assert g.waiting_for_black?
    end

    test "player can guess" do
      u1 = users(:one)
      u2 = users(:two)
      g = Game.start(user: u1)
      g.join(u2)
      g.update(word: 'abba', mask: '____')

      g.guess('x')

      assert_equal g.mask, '____'
      assert_nil g.closed_at
      assert g.waiting_for_white?

      g.guess('a')

      assert_equal g.mask, 'a__a'
      assert_nil g.closed_at
      assert g.waiting_for_white?

      g.guess('b')

      assert_equal g.mask, 'abba'
      assert g.white_won?
      refute_nil g.closed_at
      assert_operator g.closed_at.to_i, :<=, Time.now.to_i
    end  

## display game state

create a view to display the game:

    <div class="layout">
      <div class="player white <%= if @game.waiting_for_white? then 'current' end %>  <%= if @game.white_won? then 'winner' end %>">
        <% if @game.players.count > 0 %>
          <h2>Player White <%= if @game.white_won? then 'has won' end %></h2>
          <p><%= @game.white_player.no_of_guesses %> guesses, 
          <%= @game.white_player.no_of_fails %> fails.</p>
        <% end %>
      </div>

      <div class="board">
        <%= @game.mask %>
      </div>

      <div class="player black <%= if @game.waiting_for_black? then 'current' end %> <%= if @game.black_won? then 'winner' end %>">
        <% if @game.players.count > 1 %>
          <h2>Player Black <%= if @game.black_won? then 'has won' end %></h2>
          <p><%= @game.black_player.no_of_guesses %> guesses, 
          <%= @game.black_player.no_of_fails %> fails.</p>
        <% else %>
          <h2>Waiting for second player</h2>
        <% end %>
      </div>  
    </div>

