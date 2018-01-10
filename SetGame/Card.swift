import Foundation

struct Card: CustomStringConvertible, Hashable {
  var hashValue: Int {
    var hash = 0
    switch propertyOne {
    case .one: hash += 1
    case .two: hash += 2
    case .three: hash += 3
    }
    switch propertyOne {
    case .one: hash += 10
    case .two: hash += 20
    case .three: hash += 30
    }
    switch propertyOne {
    case .one: hash += 100
    case .two: hash += 200
    case .three: hash += 300
    }
    switch propertyOne {
    case .one: hash += 1000
    case .two: hash += 2000
    case .three: hash += 3000
    }
    return hash
  }

  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.propertyOne == rhs.propertyOne
      && lhs.propertyTwo == rhs.propertyTwo
      && lhs.propertyThree == rhs.propertyThree
      && lhs.propertyFour == rhs.propertyFour
  }

  var description: String {
    return "\(propertyOne) \(propertyTwo) \(propertyThree) \(propertyFour)"
  }

  let propertyOne: Properties
  let propertyTwo: Properties
  let propertyThree: Properties
  let propertyFour: Properties

  enum Properties {
    case one
    case two
    case three
    static let all = [Properties.one, .two, .three]
  }
}
