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

# deck
# - build deck
# - deal card
class Deck
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
end

# card
# - has value and suit
class Card
  def initialize(value, suit)
    @card = "#{value}#{suit}"
  end
end

deck = Deck.new
p deck


# hand
# - calculate total

# player
# - choose hit or stay
# - may also choose to bet in the future

# dealer
# - choose hit or stay (perhaps can be combined with the player)

# game
# - track if value is below 21
# - ask to hit or stay
# - compare cards
