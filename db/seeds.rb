# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

%w[javascript internet refactoring stylesheet mediaquery hypertext domainname canvas webgl webvr flexbox].each do |w|
  Vocabulary.create(word: w)
end

u1 = User.create(email: 'one@example.com', password: 'asecret', password_confirmation: 'asecret')
u2 = User.create(email: 'two@example.com', password: 'asecret', password_confirmation: 'asecret')

# game in lobby mode, waiting for second user
Game.start(user: u1)

# game in progress
g = Game.start(user: u1)
g.join(u2)
g.update(word: 'internet', mask: '_n___n__')

# game finished
g = Game.start(user: u1)
g.join(u2)
g.update(word: 'abba', mask: '____')
g.guess('a')
g.guess('b')
