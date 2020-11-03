# make code for player to guess
class CodeMaker
  attr_reader :colour_array, :code_to_break

  def initialize
    @colour_array = %w[Y G R B W O]
    @code_to_break = Array.new(4, 'W')
  end

  def random_select
    @code_to_break.each_with_index do |_rand, ind|
      @code_to_break[ind] = @colour_array[rand(6)]
    end
#    print "Code to break: #{@code_to_break.join(", ")}\n\n"
  end
end

# player who must guess code
class Game
  def initialize
    @code_maker = CodeMaker.new
    @code_maker.random_select
    @colour_array = @code_maker.colour_array
    @code_to_break = @code_maker.code_to_break
  end

  def start_game
    match_found = false

    while !match_found
      player_selecter
      check_colour
      match_found = check_order
    end
    print "\nCongratulations you have cracked the code!!!\n\n"

  end

  def player_selecter
    @player_code = []
    good_selection = false
    good_colours = false
    while !good_selection

      print "Please enter 4 colours: #{@colour_array.join(', ')} \n"
      player_input = gets.chomp.gsub(/\s+/, '').upcase
      @player_code = player_input.split('')

      @player_code.each do |code|
        good_colours = true if @colour_array.include?(code)
      end

      if good_colours && @player_code.length == 4
        print "Selected: #{@player_code.join(', ')}\n\n"
        good_selection = true
      end

    end
    @player_code
  end

  def check_colour
    player_hash = Hash.new(0)
    code_hash = Hash.new(0)
    player_match = Hash.new(0)

    @player_code.each do |colour|
      player_hash[colour] += 1
    end

    @code_to_break.each do |code|
      code_hash[code] += 1
    end

    player_hash.each do |key, value|
      if value <= code_hash[key]
        player_match[key] = value
      else
        player_match[key] = code_hash[key]
      end
    end

    player_match.each do |key, value|
      print "#{key} count: #{value}\n"
    end
  end

  def check_order
    all_match = true
    @player_code.each_with_index do |colour,ind|
      if colour == @code_to_break[ind]
        print "Match at position #{ind+1} : #{colour} \n"
      else
        all_match = false
      end
    end
    all_match
  end
end

new_game = Game.new
new_game.start_game

exit