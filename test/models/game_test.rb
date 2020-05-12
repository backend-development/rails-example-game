require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'game can be created by user' do
    u = users(:one)

    g = Game.start(user: u)
    assert_equal g.players.count, 1
    assert_equal g.players.find_by(color: 'white').user_id, u.id
    assert g.lobby?
  end

  test '2nd player can join a game in lobby-state' do
    u1 = users(:one)
    u2 = users(:two)
    g = Game.start(user: u1)
    g.join(u2)

    assert_equal g.players.count, 2
    assert_equal g.players.find_by(color: 'black').user_id, u2.id
    assert_nil g.closed_at
    assert g.waiting_for_black?
  end

  test 'player can guess' do
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
end
