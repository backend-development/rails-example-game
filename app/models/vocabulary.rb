class Vocabulary < ApplicationRecord
  def self.random
    limit(5).order('RANDOM()').first.word
  end
end
