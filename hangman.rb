require 'byebug'
require_relative 'turn_result.rb'

class Hangman

  attr_reader  :lives, :word, :guesses
  # TurnResult = Struct.new(:state, :lives, :guesses, :clue, :game_in_progress, :won, :lost)

  def initialize(word, lives)
    @word = word
    @lives = lives
    # @hangman_ui = ui
    @guesses = []
  end

  def start_game
    # byebug
    clue = build_clue(word, guesses)
    game_in_progress = game_in_progress?(word, guesses, lives)
    won = won?(word, guesses, lives)
    lost = lost?(word, guesses, lives)
    TurnResult.new("game_in_progress", lives, guesses, clue, game_in_progress, won, lost )
  end

  def play_turn(guess)
    # byebug
    result = TurnResult.new("game_in_progress", lives, guesses, nil, nil, nil, nil)

      if !valid_guess?(guess)
        result.state = "invalid_guess"
        result.lives = lives
        result.clue = build_clue(word, guesses)
        result.game_in_progress = game_in_progress?(word, guesses, lives)
        result.won = won?(word, guesses, lives)
        result.lost = lost?(word, guesses, lives)
        return result
      end

      if duplicate_guess?(guess, guesses)
        result.state = "duplicate_guess"
        result.lives = lives
        result.clue = build_clue(word, guesses)
        result.game_in_progress = game_in_progress?(word, guesses, lives)
        result.won = won?(word, guesses, lives)
        result.lost = lost?(word, guesses, lives)
        return result
      end

      guesses << guess
      if guess_correct?(guess, word)
        result.state = "guess_correct"
        result.lives = lives
        result.guesses = guesses
        result.clue = build_clue(word, guesses)
        result.game_in_progress = game_in_progress?(word, guesses, lives)
        result.won = won?(word, guesses, lives)
        result.lost = lost?(word, guesses, lives)
        return result

      else
        @lives -= 1
        result.state = "guess_incorrect"
        result.lives = lives
        result.guesses = guesses
        result.clue = build_clue(word, guesses)
        result.game_in_progress = game_in_progress?(word, guesses, lives)
        result.won = won?(word, guesses, lives)
        result.lost = lost?(word, guesses, lives)
        return result
      end
    end

  def guess_correct?(guess, word)
    word.downcase.include?(guess)
  end

  def valid_guess?(guess)
    /\A[A-Za-z]\z/.match?(guess.to_s)
  end

  def duplicate_guess?(guess, guesses)
    guesses.include?(guess)
  end

  def game_in_progress?(word, guesses, lives)
    if word_guessed?(word, guesses) && lives < 1
      raise ArgumentError, "word is guessed correctly but lives are #{lives}"
    end

    !won?(word, guesses, lives) && !lost?(word, guesses, lives)
  end

  def word_guessed?(word, guesses)
    (word.downcase.chars.uniq - guesses).empty?
  end

  def lost?(word, guesses, lives)
    !word_guessed?(word, guesses) && lives < 1
  end

  def won?(word, guesses, lives)
    word_guessed?(word, guesses) && lives >= 1
  end

  def build_clue(word, guesses)
    word.chars.map do |letter|
      guesses.include?(letter.downcase) ? letter : nil
    end
  end

  # def display_game_result(word, guesses, lives)
  #   if won?(word, guesses, lives)
  #     hangman_ui.display_won_message(word)
  #   elsif lost?(word, guesses, lives)
  #     hangman_ui.display_lost_message
  #   end
  # end
end

