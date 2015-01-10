# Object Oriented Blackjack

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

  def get_card
    @deck.pop
  end
end

class Card
  attr_reader :card, :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def format_card
    "=> #{value}#{suit}"
  end

  def to_s
    format_card
  end
end

module Hand
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

    # Additional aces calculation
    cards.select { |card| card.value == "A"}.count.times do
      total -= 10 if total > 21
    end 

    total
  end

  def deal_card(deck)
    cards << deck.get_card
  end

  def show_all_cards
    puts "#{name} has the following cards"
    puts cards
    puts "The total for #{name} is: #{calculate_total}"
    puts
  end

  def busted?
    calculate_total > 21
  end
end

class Player
  attr_reader :name
  attr_accessor :cards
  include Hand

  def initialize
    puts "Please enter your name:"
    @name = gets.chomp
    @cards = []
  end
end

class Dealer
  attr_reader :name
  attr_accessor :cards
  include Hand

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_initial_cards
    puts "#{name} has the following cards"
    puts "=> The first card is hidden."
    puts cards[1]
    puts
  end
end

class Game
  attr_reader :player, :dealer
  attr_accessor :bust, :win, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def deal_initial_cards
    puts "...Dealing initial cards..."
    player.deal_card(deck)
    dealer.deal_card(deck)
    player.deal_card(deck)
    dealer.deal_card(deck)
  end

  def check_blackjack_or_bust(dealer_or_player)
    if dealer_or_player.calculate_total == 21
      if dealer_or_player.is_a?(Dealer)
        puts "Sorry, the dealer hit blackjack. You lose!"
      else
        puts "Great #{player.name}! You hit blackjack!"
      end
      play_again?
    elsif dealer_or_player.busted?
      if dealer_or_player.is_a?(Dealer)
        puts "The dealer busted! You win, #{player.name}!"
      else
        puts "Sorry, #{player.name}. You busted."
      end
      play_again?
    end
  end

  def player_turn
    puts "----------------------------------"
    puts "#{player.name}'s turn."

    check_blackjack_or_bust(player)

    while !player.busted?
      puts "Would you like to (h)it or (s)tay?"
      response = gets.chomp.downcase

      if !['h', 's'].include?(response)
        puts "Please enter either 'h' or 's'."
        next
      end

      if response == 's'
        puts "#{player.name} decided to stay."
        puts
        break
      end

      puts "...Dealing new card to #{player.name}..."
      player.deal_card(deck)
      player.show_all_cards

      check_blackjack_or_bust(player)
    end

    puts "#{player.name} stays. The total is: #{player.calculate_total}."
  end

  def dealer_turn
    puts "----------------------------------"
    puts "Dealer's turn."
    dealer.show_all_cards

    check_blackjack_or_bust(dealer)

    while dealer.calculate_total < 17
      puts "...Dealing new card to the dealer..."
      dealer.deal_card(deck)
      dealer.show_all_cards

      check_blackjack_or_bust(dealer)
    end
    puts "Dealer stays. The total is: #{dealer.calculate_total}."
    puts
  end

  def check_winner
    if player.calculate_total > dealer.calculate_total
      puts "Great, #{player.name}. You've won!"
    elsif dealer.calculate_total > player.calculate_total
      puts "Sorry, #{player.name}. The dealer won!"
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts
    puts "Would you like to play again? (y/n)"

    response = gets.chomp.downcase

    if response == "y"
      self.deck = Deck.new
      player.cards = []
      dealer.cards = []
      play
    else
      puts "Thank you for playing! Bye!"
      exit
    end
  end

  def play
    system "clear"
    puts "Hello #{player.name}. Welcome to the game of Blackjack!"
    puts
    deal_initial_cards
    player.show_all_cards
    dealer.show_initial_cards
    player_turn
    dealer_turn
    check_winner
  end
end

Game.new.play
