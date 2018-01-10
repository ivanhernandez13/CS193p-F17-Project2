// swiftlint:disable fallthrough

import Foundation

class SetGame {
  var deck = Deck()

  var score = 0
  var isMatch: Bool?
  var hasAndIsMatch: Bool {
    return isMatch != nil && isMatch!
  }
  // contains cards currently being displayed to the user.
  var visibleCards = [Card?]()
  // contains cards currently selected by the user.
  var selectedCards = Set<Card>()
  // contains cards that were just matched in the last move.
  var matchedCardIndices = [Int]()

  func selectCard(_ index: Int) {
    var currentState = GameState.unknownState
    if let card = visibleCards[index], let newIndex = deck.indexOfCard(card) {
      currentState = determineGameState(withIndex: newIndex)
      print(currentState)
    }

    switch currentState {
    case .selectedPreviouslySelectedCard:
      //if let cardIndex = selectedCards.index(of: deck.cardAtIndex(index)) {
      if let cardIndex = selectedCards.index(of: visibleCards[index]!) {
        selectedCards.remove(at: cardIndex)
      } else {
        print("Could not get index of card \(deck.cardAtIndex(index))")
      }

    case .selectedMatchedCard:
      replaceMatchedCards()

    case .selectedNewCardAfterMatch:
      replaceMatchedCards()
      print("Card left in deck: \(deck.cardsRemaining)")
      fallthrough

    case .selectedNewCard:
      //selectedCards.insert(deck.cardAtIndex(index))
      if let visibleCard = visibleCards[index] {
        selectedCards.insert(visibleCard)
      } else {
        print("Picked card is not in visibecards")
      }

      if selectedCards.count == Constants.maxSelectedCards {
        isMatch = checkForMatch()
        if isMatch! {
          for card in selectedCards {
            if let newIndex = visibleCards.index(where: {$0 == card}) {
              matchedCardIndices.append(newIndex)
            }

            //if let newIndex = deck.cards.index(of: card) {
              //matchedCardIndices.append(newIndex)
            //}
          }
        }

        score += (isMatch! ? 3 : -5)
      }
      
    case .unknownState:
      assert(currentState != .unknownState, "Should never in unknown state.")
    }
  }

  func replaceMatchedCards() {
    for matchedCardIndex in matchedCardIndices {
      if let nextCard = deck.drawCard() {
        visibleCards[matchedCardIndex] = nextCard
      } else {
        print("Failed to draw a card.")
        print("Removing at index \(index) from visible cards with count \(visibleCards.count)")
        if matchedCardIndex < visibleCards.count {
          //visibleCards.remove(at: index)
          visibleCards[matchedCardIndex] = nil
        } else {
          print("Failed to remove at index \(index) from visible cards with count \(visibleCards.count)")
        }
      }
    }

    selectedCards.removeAll()
    matchedCardIndices.removeAll()
    isMatch = nil
  }

  func checkForMatch() -> Bool {
    //return true // uncomment for easy mode.
    assert(selectedCards.count == SetGame.Constants.maxSelectedCards)

    let card1 = selectedCards[selectedCards.startIndex]
    let card2 = selectedCards[selectedCards.index(selectedCards.startIndex,
                                                  offsetBy: 1)]
    let card3 = selectedCards[selectedCards.index(selectedCards.startIndex,
                                                  offsetBy: 2)]
    let easyMode = false

    if card1.propertyOne == card2.propertyOne
      || card1.propertyOne == card3.propertyOne
      || card2.propertyOne == card3.propertyOne {
      return false
    }

    if !easyMode {
    if card1.propertyTwo == card2.propertyTwo
      || card1.propertyTwo == card3.propertyTwo
      || card2.propertyTwo == card3.propertyTwo {
      return false
    }

    if card1.propertyThree == card2.propertyThree
      || card1.propertyThree == card3.propertyThree
      || card2.propertyThree == card3.propertyThree {
      return false
    }

    if card1.propertyFour == card2.propertyFour
      || card1.propertyFour == card3.propertyFour
      || card2.propertyFour == card3.propertyFour {
      return false
    }
    }

    return true
  }

  init() {
    drawCardsAtStart()
  }

  func drawCardsAtStart() {
    for _ in 0..<Constants.cardsToDrawAtStart {
      visibleCards.append(deck.drawCard()!)
    }
  }

  func drawCards() {
    for _ in 0..<Constants.cardsToDraw {
      visibleCards.append(deck.drawCard()!)
    }
    print("Card left in deck: \(deck.cardsRemaining)")
  }

  func newGame() {
    deck.resetDeck()
    visibleCards.removeAll()
    selectedCards.removeAll()
    matchedCardIndices.removeAll()
    score = 0
    drawCardsAtStart()
  }

  func determineGameState(withIndex index: Int) -> GameState {
    if isMatch == nil && selectedCards.contains(deck.cardAtIndex(index)) {
      return .selectedPreviouslySelectedCard
    } else if hasAndIsMatch && matchedCardIndices.contains(index) {
      return .selectedMatchedCard
    } else if selectedCards.count == Constants.maxSelectedCards {
      return .selectedNewCardAfterMatch
    } else {
      return .selectedNewCard
    }
  }

  enum GameState {
    case selectedPreviouslySelectedCard
    case selectedMatchedCard
    case selectedNewCard
    case selectedNewCardAfterMatch
    case unknownState
  }

  struct Constants {
    static let maxSelectedCards = 3
    static let cardsToDraw = 3
    static let cardsToDrawAtStart = 12
  }
}
