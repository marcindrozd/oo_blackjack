# We take a deck of cards and deal 2 cards to the player and the dealer The
# value of cards are face values, J-K are 10 and A is either 11 or 1, whichever
# is better for the player.
# If player's cards value is 21, he has a blackjack and wins. If it is over 21,
# he busts and loses.
# If player is below 21, he may choose to either hit or stay. Hit - gives another
# card to the player. Stay - the player choses to stay with current value and it 
# is then the dealer's turn.
# Dealer takes additional card until he is over 17. If the dealer has 21, he wins
# if the dealer goes over 21, he busts.
# If nobody has busted or has 21 the card values are compared, whoever has the most
# wins, or if it is the same, it is a tie.

require "pry"

# deck
# - build deck
# - deal card
class Deck
  attr_reader :deck

  VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
  SUITS = ["D", "H", "C", "S"]

  def initialize
    @deck = []
    VALUES.each do |value|
      SUITS.each do |suit|
        @deck << Card.new(value, suit)
      end
    end
    @deck.shuffle!
  end

  def deal_card
    @deck.pop
  end
end

# card
# - has value and suit
class Card
  attr_reader :card, :value

  def initialize(value, suit)
    @value = value
    @card = "#{value}#{suit}"
  end
end

# deck = Deck.new
# p deck


# hand
# - hold cards
# - calculate total
class Hand
  attr_accessor :cards

  def initialize(deck)
    @cards = []
    2.times { @cards << deck.deal_card }
  end

  def calculate_total
    total = 0
    cards.each do |card|
      if card.value.to_i != 0
        total += card.value.to_i
      elsif card.value == "A"
        total += 11
      else
        total += 10
      end
    end
    total
  end

  def hit(deck)
    cards << deck.deal_card
  end

  def display_cards
    to_display = []
    cards.each do |a|
      to_display << a.card
    end
    to_display.join(", ")
  end
end

# deck = Deck.new
# player_hand = Hand.new(deck)

# p player_hand
# p player_hand.calculate_total
# p deck.deck.size

# player
# - choose hit or stay
# - may also choose to bet in the future
class Player
  attr_reader :name

  def initialize
    puts "Please enter your name:"
    @name = gets.chomp
  end

  def stay
    puts "You've decided to stay."
  end
end

# dealer
# - choose hit or stay (perhaps can be combined with the player)
class Dealer
  def initialize
    puts "Hello, I'm the dealer"
  end

  def hit(hand, deck)
    hand << deck.deal_card
  end

  def stay
    puts "Dealer decided to stay."
  end
end

# game
# - track if value is below 21
# - ask to hit or stay
# - compare cards

class Game
  attr_reader :player_hand, :dealer_hand, :deck, :player, :dealer
  attr_accessor :bust, :win

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @player_hand = Hand.new(@deck)
    @dealer_hand = Hand.new(@deck)
    @bust = false
    @win = false
  end

  def check_cards(whose_hand)
    if whose_hand.calculate_total == 21
      self.win = true
    elsif whose_hand.calculate_total > 21
      self.bust = true
    end
  end

  def play

    while !bust && !win
      puts "Player has the following cards: #{player_hand.display_cards}."
      puts "The total in player's hand is: #{player_hand.calculate_total}"

      begin
        puts "Would you like to hit or stay? (h/s)"
        response = gets.chomp.downcase
      end until ['h', 's'].include?(response)

      if response == 'h'
        player_hand.hit(deck)
      else
        player.stay
        break
      end

      check_cards(player_hand)
    end


    # loop
    # check if bust
    # elsif check if 21
    # else ask if wants hit or stay
    # 
    # if stay dealer turn
    # check if bust
    # elsif check if 21
    # else if < 17 hit

    # if nobody busts or wins > compare cards

    # display final message similar to tic tac toe
    # either player has blackjack or dealer has blackjack
    # or either player busts or dealer busts
    # or either player wins or dealer wins
    # or it's a tie!
    puts "Dealer has the following cards: #{dealer_hand.display_cards}."
    puts "The total in dealer's hand is: #{dealer_hand.calculate_total}"

  end
end

Game.new.play
