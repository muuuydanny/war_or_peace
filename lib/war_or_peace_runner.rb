require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'turn'

class Runner
  def start
    p "Welcome to War! (or Peace) This game will be played with 52 cards."
    p "The players today are Megan and Aurora."
    p "Type 'GO' to start the game!"

    go = gets.chomp

    if go == "GO"
      standard_deck = create_standard_deck
      players  = create_two_players(standard_deck)
      start_game(players.first, players.last)
    else
      puts "Maybe next time!"
    end
  end

  def  create_two_players(deck)
    deck.shuffle
    p "Enter player 1 name"
    player1_name = gets.chomp
    p "Enter player 2 name"
    player2_name = gets.chomp
    take_half = deck.slice!(0..((deck.length - 1)  / 2))
    remaining_half = deck
    player1 = Player.new(player1_name, Deck.new(take_half))
    player2 = Player.new(player2_name, Deck.new(remaining_half))
    [player1, player2]
  end

  def create_standard_deck
    cards = []
    [:heart, :spades, :diamond, :clubs].each do |suit|
      cards << Card.new(suit, "Two", 2)
      cards << Card.new(suit, "Three", 3)
      cards << Card.new(suit, "Four", 4)
      cards << Card.new(suit, "Five", 5)
      cards << Card.new(suit, "Six", 6)
      cards << Card.new(suit, "Seven", 7)
      cards << Card.new(suit, "Eight", 8)
      cards << Card.new(suit, "Nine", 9)
      cards << Card.new(suit, "Ten", 10)
      cards << Card.new(suit, "Jack", 11)
      cards << Card.new(suit, "Queen", 12)
      cards << Card.new(suit, "King", 13)
      cards << Card.new(suit, "Ace", 14)
    end
    cards
  end

  def start_game(player1, player2)
    player1_score = 0
    player2_score = 0
    turn_count = 0
    until player1.has_lost? or player2.has_lost? or turn_count == 1_000_000
      turn = Turn.new(player1, player2)
      turn_count += 1
      winner = turn.winner
      if winner.name == player1.name
        player1_score += 1
      else
        player2_score += 1
      end
      spoiled_cards = turn.award_spoils(winner)
      p "#{winner.name} has won #{spoiled_cards} cards"
      p "******"
      p "#{player1.name} score:", player1_score
      p "******"
      p "#{player2.name} score:", player2_score
    end

    if player1_score > player2_score
      p "#{player1.name} wins everything!"
    elsif player2_score > player1_score
      p "#{player2.name} wins everything!"
    else
      p "Draw!"
    end
  end
end

runner = Runner.new
runner.start
