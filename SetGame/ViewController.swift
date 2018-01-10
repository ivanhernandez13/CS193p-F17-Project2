// swiftlint:disable cyclomatic_complexity

import UIKit

class ViewController: UIViewController {
  var game = SetGame()

  @IBOutlet var cardButtons: [UIButton]!
  @IBOutlet var scoreLabel: UILabel!
  @IBOutlet var remainingCardsLabel: UILabel!
  @IBOutlet var drawThreeCardsButton: UIButton!

  @IBAction func cardTapped(_ sender: UIButton) {
    assert(cardButtons.index(of: sender) != nil)

    if let cardButtonIndex = cardButtons.index(of: sender) {
      game.selectCard(cardButtonIndex)
    }
    updateViewFromModel()
  }

  @IBAction func drawThreeCardsButtonTapped() {
    game.hasAndIsMatch ? game.replaceMatchedCards() : game.drawCards()
    updateViewFromModel()
  }

  @IBAction func newGameButtonTapped() {
    game.newGame()
    var index = 0
    for cardButton in cardButtons {
      cardButton.alpha = index < 12 ? 1.0 : 0.0
      let emptyString = NSAttributedString(string: "", attributes: nil)
      cardButton.setAttributedTitle(emptyString, for: UIControlState.normal)
      index += 1
    }
    updateViewFromModel()
  }

  func updateViewFromModel() {
    updateScoreLabel()
    updateRemainingCardsLabel()
    enableOrDisableDrawThreeCardsButton()

    var cardButtonIndex = 0
    for card in game.visibleCards {
      assert(cardButtonIndex < cardButtons.count)

      let cardButton = cardButtons[cardButtonIndex]

      if card != nil {
        // Show/Hide and set border colors for selected cards.
        if game.selectedCards.contains(card!) {
          if let isMatch = game.isMatch {
            let color = isMatch ? UIColor.green.cgColor : UIColor.red.cgColor
            cardButton.layer.borderColor = color
          } else {
            cardButton.layer.borderColor = UIColor.yellow.cgColor
          }
          cardButton.layer.borderWidth = 3.0
        } else {
          cardButton.layer.borderWidth = 0.0
        }

        // Set proper title for card
        let attrTitle = getAttributedStringForCard(card!, orientation: UIApplication.shared.statusBarOrientation)
        cardButton.setAttributedTitle(attrTitle, for: UIControlState.normal)
      }

      cardButtonIndex += 1
      cardButton.alpha = card == nil ? 0.0 : 1.0
    }
  }

  func updateScoreLabel() {
    scoreLabel.text = "Score: \(game.score)"
  }
  func updateRemainingCardsLabel() {
    remainingCardsLabel.text = "Remaining Cards: \(game.deck.cardsRemaining)"
  }
  func enableOrDisableDrawThreeCardsButton() {
    let maximumCardsInView = 24
    if (game.visibleCards.count == maximumCardsInView && !game.hasAndIsMatch)
        || game.deck.cardsRemaining == 0 {
      drawThreeCardsButton.isEnabled = false
      drawThreeCardsButton.setTitleColor(UIColor.gray,
                                         for: UIControlState.normal)
    } else {
      drawThreeCardsButton.isEnabled = true
      drawThreeCardsButton.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: UIControlState.normal)
    }
  }

  func getAttributedStringForCard(_ card: Card, orientation: UIInterfaceOrientation) -> NSAttributedString {
    var attributes = [NSAttributedStringKey: Any]()
    var attributedString: NSMutableAttributedString

    // Color
    switch card.propertyOne {
    case Card.Properties.one:
      attributes[NSAttributedStringKey.strokeColor] = UIColor.red
      attributes[NSAttributedStringKey.foregroundColor] = UIColor.red
    case Card.Properties.two:
      attributes[NSAttributedStringKey.strokeColor] = UIColor.green
      attributes[NSAttributedStringKey.foregroundColor] = UIColor.green
    case Card.Properties.three:
      attributes[NSAttributedStringKey.strokeColor] = UIColor.blue
      attributes[NSAttributedStringKey.foregroundColor] = UIColor.blue
    }

    // Shading
    switch card.propertyTwo {
    case Card.Properties.one:
      attributes[NSAttributedStringKey.strokeWidth] = 0
    case Card.Properties.two:
      attributes.removeValue(forKey: NSAttributedStringKey.foregroundColor)
      attributes[NSAttributedStringKey.strokeWidth] = 10
    case Card.Properties.three:
      if let currentColor = attributes[NSAttributedStringKey.foregroundColor] {
        attributes[NSAttributedStringKey.foregroundColor] =
          (currentColor as? UIColor)?.withAlphaComponent(0.2)
      }
    }

    // Shape
    switch card.propertyThree {
    case Card.Properties.one:
      attributedString =
        NSMutableAttributedString(string: "▲", attributes: attributes)
    case Card.Properties.two:
      attributedString =
        NSMutableAttributedString(string: "●", attributes: attributes)
    case Card.Properties.three:
      attributedString =
        NSMutableAttributedString(string: "■", attributes: attributes)
    }
    
    let isVertical = (orientation == UIInterfaceOrientation.portrait
      || orientation == UIInterfaceOrientation.portraitUpsideDown)
    let delimiter = isVertical ? "\n" : " "
    
    // Number
    switch card.propertyFour {
    case Card.Properties.one:
      break
    case Card.Properties.two:
      attributedString.mutableString
        .setString(attributedString.string + delimiter + attributedString.string)
    case Card.Properties.three:
      attributedString.mutableString
        .setString(attributedString.string + delimiter + attributedString.string
                   + delimiter + attributedString.string)
    }

    return attributedString
  }

  override func viewWillAppear(_ animated: Bool) {
    var index = 0
    for cardButton in cardButtons {
      if index >= 12 {
        cardButton.alpha = 0.0
      }
      cardButton.layer.cornerRadius = 8.0
      cardButton.titleLabel?.numberOfLines = 0
      index += 1
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateViewFromModel()
  }
  
  override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    var cardButtonIndex = 0
    for card in game.visibleCards {
      let cardButton = cardButtons[cardButtonIndex]
      let attrTitle = getAttributedStringForCard(card!, orientation: toInterfaceOrientation)
      cardButton.setAttributedTitle(attrTitle, for: UIControlState.normal)
      cardButtonIndex += 1
    }
  }
}
