require "pry"

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

class Card
  attr_reader :card, :value

  def initialize(value, suit)
    @value = value
    @card = "#{value}#{suit}"
  end
end

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

    # Additional aces calculation
    cards.select { |card| card.value == "A"}.count.times do
      total -= 10 if total > 21
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

class Player
  attr_reader :name

  def initialize(type)
    if type == "player"
      puts "Please enter your name:"
      @name = gets.chomp
    else
      @name = "Hank the Dealer"
    end
  end

  def stay
    puts "#{name} decides to stay."
  end
end

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

class Game
  attr_reader :player_hand, :dealer_hand, :deck, :player, :dealer
  attr_accessor :bust, :win

  def initialize
    @player = Player.new("player")
    @dealer = Player.new("dealer")
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

  def display_cards_message(whose_hand, name)
    puts "#{name.capitalize} has the following cards: #{whose_hand.display_cards}."
    puts "The total in #{name}'s hand is: #{whose_hand.calculate_total}"
  end

  def display_final_message(player_hand, dealer_hand)
    if player_hand.calculate_total == 21
      puts "Blackjack! Player wins!"
    elsif dealer_hand.calculate_total == 21
      puts "Blackjack! Dealer wins!"
    elsif player_hand.calculate_total > 21
      puts "Player busts!"
    elsif dealer_hand.calculate_total > 21
      puts "Dealer busts!"
    elsif player_hand.calculate_total > dealer_hand.calculate_total
      puts "Player wins!"
    elsif dealer_hand.calculate_total > player_hand.calculate_total
      puts "Dealer wins!"
    else
      puts "It's a tie!"
    end
  end


  def play
    system "clear"
    while !bust && !win
      system "clear"
      # show first card from the dealer
      display_cards_message(player_hand, "player")

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

    if !bust && !win
      display_cards_message(dealer_hand, "dealer")

      while dealer_hand.calculate_total < 17
        dealer_hand.hit(deck)
      end
    end
    system "clear"
    display_cards_message(player_hand, "player")
    display_cards_message(dealer_hand, "dealer")

    display_final_message(player_hand, dealer_hand)

  end
end

Game.new.play
