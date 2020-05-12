require 'test_helper'

class VocabularyTest < ActiveSupport::TestCase
  test 'can give randome word' do
    w = Vocabulary.random
    assert_match(/.../, w)
  end
end
