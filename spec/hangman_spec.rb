require_relative '../hangman_game_state'
require_relative '../hangman_console_ui'

require 'rspec'

RSpec.describe HangmanGameState do
  let(:lives) { 8 }
  let(:remaining_lives) { 8 }
  let(:word) { "bangladesh" }
  let(:guesses) { [] }
  let(:guess) { 'a' }
  subject(:game) { HangmanGameState.new(word, lives) }

  describe "#validate_guess" do
    let(:validate_guess) { game.validate_guess(guess) }

    context "#not a valid_guess?" do
      let(:guess) { '@' }

      it "tells the player the guess is not valid" do
        expect(validate_guess).to eq :invalid_guess
      end
    end

    context "when the player guessed the same right letter twice" do
      let(:guess) { 'b' }

      before do
        expect(game.validate_guess(guess)).to eql :guess_correct
      end

      it "tells the player the guess is duplicate" do
        expect(game.validate_guess(guess)).to eql :duplicate_guess
      end
    end

    context "when the player guessed the same wrong letter twice" do
      let(:guess) { 'q' }

      before do
        expect(game.validate_guess(guess)).to eql :guess_incorrect
      end

      it "tells the player the guess is duplicate" do
        expect(game.validate_guess(guess)).to eql :duplicate_guess
      end
    end

    context "#guess_correct" do
      let(:guess) { 'l' }
      it "tells the player the guess is correct" do
        expect(validate_guess).to eq :guess_correct
      end
    end

    context "#guess_incorrect" do
      let(:guess) { 'q' }

      it "tells the player the guess is incorrect" do
        expect(validate_guess).to eq :guess_incorrect
      end
    end
  end

  describe "#word_guessed?" do
    let(:word) { "Hello" }

      before do
        expect(game).to receive(:guesses).and_return(guesses)
      end

    context 'when the word is guessed correctly' do

      context 'with letters ordered as they appear in the word' do
        let(:guesses) {['h', 'e', 'l', 'o']}

        it 'returns true' do
          expect(game.word_guessed?).to be true
        end
      end

      context 'with letters ordered differently' do
        let(:guesses) {['l', 'o', 'h', 'e']}

        it 'returns true' do
          expect(game.word_guessed?).to be true
        end
      end
    end
  end

  xdescribe "#won?" do
    let(:word) { "flux" }
    let(:game_won) { game.won? }

    before do
      expect(game).to receive(:guesses).and_return(guesses)
      # expect(game).to receive(:remaining_lives).and_return(8)
      expect(game).to receive(:remaining_lives)
      .and_return(remaining_lives)
    end

    context "when the word is guessed" do
      let(:guesses) { word.chars }

      context "when player has lives remaining" do
        let(:remaining_lives) { 8 }

        it "returns true" do
          # expect(game).to receive(:remaining_lives).and_return(8)
          expect(game_won).to be true
        end
      end

      context "when player has no lives remaining" do
        let(:remaining_lives) { 0 }

        it "returns false" do
          # expect(game).to receive(:remaining_lives).and_return(0)
          expect(game_won).to be false
        end
      end
    end

    context "when the word is not guessed" do
      let(:guesses) { ['f', 'i', 'k'] }

      context "when player has lives remaining" do
        let(:remaining_lives) { 5 }

        it "returns false" do
          expect(game_won).to be false
        end
      end

      context "when player has no lives remaining" do
        let(:remaining_lives) { 0 }

        it "returns false" do
          expect(game_won).to be false
        end
      end
    end
  end

  describe "#lost?" do
    let(:word) { "flux" }
    let(:game_lost) { game.lost? }

    context "when the player has started the game" do

      it "will return false" do
        expect(game_lost).to be false
      end
    end

    context "when the player has lives remaining" do
      before do
        game.validate_guess(guess)
      end

      context "and the player guessed the wrong letter" do
        let(:guess) { 'q' }

        it "returns false" do
          expect(game_lost).to be false
        end
      end

      context "and the player guessed the right letter" do
        let(:guess) { 'f' }

        it "returns false" do
          expect(game_lost).to be false
        end
      end
    end

    context "when the player has no lives remaining" do
      let(:guess) { 'q' }

      before do
        game.validate_guess(guess)
      end

      it "will return true" do
        expect(game_lost).to be true
      end
    end


  end
end
#
#   describe "#game_in_progress?" do
#     let(:word) { "Hello" }
#     subject(:game_in_progress) { game.game_in_progress?(word, guesses, lives) }
#
#     context "when player has not won the game" do
#       let(:guesses) { ['a', 'e', 'w', 'h'] }
#
#       context "and the player has not lost the game either" do
#         let(:lives) { 5 }
#
#         it "returns true" do
#           expect(game_in_progress).to be true
#         end
#       end
#
#       context "but the player has lost the game" do
#         let(:lives) { 0 }
#
#         it "returns false" do
#           expect(game_in_progress).to be false
#         end
#       end
#     end
#
#     context "when player has won the game" do
#       let(:guesses) { ['l', 'e', 'o', 'h'] }
#
#       context "and the player has not lost the game either" do
#         let(:lives) { 5 }
#
#         it "returns false" do
#           expect(game_in_progress).to be false
#         end
#       end
#
#       context "but the player has lost the game" do
#         let(:lives) { 0 }
#
#         it "raises an error" do
#           expect { game_in_progress }.to raise_error(ArgumentError, "word is guessed correctly but lives are 0")
#         end
#       end
#     end
#   end
# end
