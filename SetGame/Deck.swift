import Foundation

struct Deck {
  private(set) var cards = [Card]()

  var cardsRemaining: Int {
    return cards.count - index
  }
  private var index = 0

  init() {
    for one in Card.Properties.all {
      for two in Card.Properties.all {
        for three in Card.Properties.all {
          for four in Card.Properties.all {
            cards.append(Card(propertyOne: one,
                              propertyTwo: two,
                              propertyThree: three,
                              propertyFour: four))
          }
        }
      }
    }

    shuffle()
  }

  mutating func drawCard() -> Card? {
    if index < cards.count {
      let card = cards[index]
      index +=  1
      return card
    }

    return nil
  }

  func cardAtIndex(_ index: Int) -> Card {
    return cards[index]
  }
  
  func indexOfCard(_ card: Card) -> Int? {
    return cards.index(where: {$0 == card})
  }

  mutating func shuffle() {
    var cardsCopy = cards
    cards.removeAll()

    while !cardsCopy.isEmpty {
      cards.append(cardsCopy.remove(at: Int.arc4random(cardsCopy.count)))
    }
  }

  mutating func resetDeck() {
    index = 0
    shuffle()
  }
}

extension Int {
  static func arc4random(_ upperBound: Int) -> Int {
    return Int(arc4random_uniform(UInt32(upperBound)))
  }
}
