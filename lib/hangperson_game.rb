class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses
  attr_accessor :check_win_or_lose
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-'*@word.length
    @check_win_or_lose = :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letters)
    if letters == '' or letters == nil
      raise ArgumentError, 'Input is blank'
    end
    letters = letters.split('')
    counter = 0
    while counter < letters.length
      letter = letters[counter].downcase
      if @guesses.include? letter or @wrong_guesses.include? letter
        return false
      elsif !(letter =~ /[A-Za-z]/)
        raise ArgumentError, 'Input is not a letter'
      end
      if @word.include? letter 
        @guesses += letter
      else
        @wrong_guesses += letter
      end
      counter += 1
    end
    displayed = ''
    counter = 0
    while counter < @word.length
      if @guesses.include? word[counter]
        displayed += word[counter]
      else
        displayed += '-'
      end
      counter += 1
    end
    @word_with_guesses = displayed
    if @wrong_guesses.length >= 7
      @check_win_or_lose = :lose
    elsif not @word_with_guesses.include? '-'
      @check_win_or_lose = :win
    end
    return true
  end

end
