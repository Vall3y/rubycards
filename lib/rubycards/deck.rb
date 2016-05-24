require 'forwardable'

module RubyCards
  class Deck

    include Enumerable
    extend Forwardable

    attr_reader :cards

    def_delegators :cards, :empty?, :[], :shift

    alias :draw :shift

    RANKS = [*2..10, 'Jack', 'Queen', 'King', 'Ace']
    SUITS = %w{ Clubs Diamonds Hearts Spades }

    # Initializes a standard deck of 52 cards
    # options:
    #   :number_decks
    #     eg. Deck.new(number_decks: 2)
    #     will create 2 decks standard decks of 52
    #   :exclude_rank
    #     eg. Deck.new(exclude_rank: [2,'Jack'])
    #     will exclude 8 cards of the 2 and Jack rank
    #
    # @return [Deck] A standard deck of cards
    def initialize(options={})
      @cards = []
      options[:exclude_rank] ||= []
      options[:number_decks] ||= 1

      options[:number_decks].times do
        (RANKS - options[:exclude_rank]).product(SUITS).each do |rank, suit|
          @cards << Card.new(rank, suit)
        end
      end
    end

    # Dumps into a string that can be loaded with #loads
    def dumps
      cards = self.map do |card|
        {
          rank: card.rank,
          card: card.suit
        }
      end

      cards.to_json
    end

    # Loads a deck that was dumped using #dumps
    def self.loads(str)
      card_raws = JSON.parse(str)

      deck = Deck.new(number_decks: 0)

      card_raws.each do |card_raw|
        deck.cards << Card.new(card.rank, card.suit)
      end
    end

    # Shuffles the deck and returns it
    #
    # @return [Deck] The shuffled deck
    def shuffle!
      @cards.shuffle!
      self
    end

    # Cuts the deck and returns it
    #
    # @param index [Integer] The index of the card that will be cut
    # @return [Deck] The cut deck
    def cut!(index)
      (0..index).each { @cards << @cards.shift }
      self
    end

    # Enumerates the deck
    #
    # @param block [Proc] The block to pass into the enumerator
    # @return [Enumerable] The deck enumerator
    def each(&block)
      @cards.each(&block)
    end

    # Displays concise card representations in an array
    #
    # @return [String] The concise string representation of the deck
    def to_s
      "[ #{@cards.map(&:inspect).join ', '} ]"
    end

    # Displays a shortened version of the #to_s method for use in the
    # ruby console
    #
    # @return [String] A shortened string output of the deck
    def inspect
      "[ #{@cards[0..2].map(&:inspect).join ', '}, ..., #{@cards[-3..-1].map(&:inspect).join ', '} ]"
    end

  end
end
