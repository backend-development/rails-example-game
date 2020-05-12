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
    
