# initalize colour array values and set random array
class CodeMaker
  attr_reader :colour_array, :random_code

  def initialize
    @colour_array = %w[Y G R B W O]
    @random_code  = [@colour_array[rand(6)], @colour_array[rand(6)],
                     @colour_array[rand(6)], @colour_array[rand(6)]]
  end
end

# main game code
class Game
  def initialize
    @code_maker = CodeMaker.new
    @colour_array = @code_maker.colour_array
    @code_to_break = @code_maker.random_code
  end

  def start_game
    match_found = false
    guess_count = 0
    colour_match = {}
    colour_order_match = []
    player_code_creation = player_code_creation_select

    @code_to_break = enter_code("\nPlease create code of 4 colours: ") if player_code_creation

    until match_found
      guess = if player_code_creation
                computer_guess(colour_match, colour_order_match)
              else
                guess = enter_code("\nPlease guess 4 colour code: ")
              end

      colour_match = check_colour(guess)
      colour_order_match = check_order(guess)
      match_found = true if colour_order_match == @code_to_break
      guess_count += 1
    end
    print "\nCongratulations you have cracked the code after #{guess_count} tries!!!\n\n"
  end

  def computer_guess(colour_match, colour_order_match)
    guess = ['', '', '', '']
    new_colour_array = @colour_array

    colour_match.each do |key, _value|
      new_colour_array.delete(key) if colour_match[key].zero?
    end

    len = new_colour_array.length

    colour_order_match.each_with_index do |colour, ind|
      guess[ind] = colour == '' ? new_colour_array[rand(len)] : colour
    end
    guess
  end

  def player_code_creation_select
    answer = ''
    while answer != 'Y' && answer != 'N'
      print 'Player to select code? (Y/N) : '
      answer = gets.chomp.upcase
    end
    answer == 'Y'
  end

  def enter_code(in_str)
    entered_code = []
    good_selection = false

    until good_selection
      print "#{in_str} #{@colour_array.join(', ')} \n"
      player_input = gets.chomp.gsub(/\s+/, '').upcase
      entered_code = player_input.split('')
      good_colours = true

      entered_code.each do |code|
        good_colours = false unless @colour_array.include?(code)
      end

      if good_colours && entered_code.length == 4
        print "Selected: #{entered_code.join(', ')}\n\n"
        good_selection = true
      end
    end
    entered_code
  end

  def check_colour(guess_code)
    guess_hash = Hash.new(0)
    code_hash = Hash.new(0)
    colour_match = Hash.new(0)

    guess_code.each do |colour|
      guess_hash[colour] += 1
    end

    @code_to_break.each do |code|
      code_hash[code] += 1
    end

    guess_hash.each do |key, value|
      colour_match[key] = if value <= code_hash[key]
                            value
                          else
                            code_hash[key]
                          end
    end

    colour_match.each do |key, value|
      print "#{key} count: #{value}\n" unless key == ''
    end
    colour_match
  end

  def check_order(guess_code)
    colour_order_match = ['', '', '', '']
    guess_code.each_with_index do |colour, ind|
      if colour == @code_to_break[ind]
        print "Match at position #{ind + 1} : #{colour} \n"
        colour_order_match[ind] = colour
      end
    end
    colour_order_match
  end
end

new_game = Game.new
new_game.start_game
