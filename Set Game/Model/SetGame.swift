//
//  SetGame.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/15/20.
//

import Foundation

struct SetGame<VisualCardContent> {
	
	struct Card: Identifiable {
		let id: Int
		var wasDealt: Bool = false // need this one
		var isMatched: Bool = false
		var isDiscarded: Bool = false // need this one
		/// CardContent is a tuple of four Ints
		let visualContent: VisualCardContent
		var features: [FeaturePossibility]
		var matchState: MatchState = MatchState.none
	}
	
	private(set) var cards: [Card]
	
	enum FeaturePossibility: CaseIterable {
		case one
		case two
		case three
	}
	
	init(visualCardContentFactory: (FeaturePossibility, FeaturePossibility, FeaturePossibility, FeaturePossibility) -> VisualCardContent) {
		cards = Array<Card>()
		for featureOnePossibility in 0..<FeaturePossibility.allCases.count {
			for featureTwoPossibility in 0..<FeaturePossibility.allCases.count {
				for featureThreePossibility in 0..<FeaturePossibility.allCases.count {
					for featureFourPossibility in 0..<FeaturePossibility.allCases.count {
						let content = visualCardContentFactory(
							FeaturePossibility.allCases[featureOnePossibility], FeaturePossibility.allCases[featureTwoPossibility], FeaturePossibility.allCases[featureThreePossibility], FeaturePossibility.allCases[featureFourPossibility]
						)
						cards.append(Card(
							id: cards.count,
							visualContent: content,
							features: [
								FeaturePossibility.allCases[featureOnePossibility],
								FeaturePossibility.allCases[featureTwoPossibility],
								FeaturePossibility.allCases[featureThreePossibility],
								FeaturePossibility.allCases[featureFourPossibility]
							]
						))
					}
				}
			}
		}
		cards.shuffle()
		
	}
	
	private var cardsDealt: Int {
		cards.filter { card in
			card.wasDealt == true
		}.count
	}
	
	mutating func deal() {
		for card in cardsDealt..<max(12,min(cardsDealt+3,cards.count)) {
			cards[card].wasDealt = true
		}
	}

	enum MatchState {
		case none
		case selected
		case potentialMatch
		case mismatched
		case matched
	}
	
	private var selectedCards: [Card] {
		cards.filter({ card in cards[cards.firstIndex(matching: card)!].matchState == .selected })
	}
	
	private var potentialMatches: [Card] {
		cards.filter({ card in cards[cards.firstIndex(matching: card)!].matchState == .potentialMatch })
	}
	
	private var matchedCards: [Card] {
		cards.filter({ card in cards[cards.firstIndex(matching: card)!].matchState == .matched })
	}
	
	private var mismatchedCards: [Card] {
		cards.filter({ card in cards[cards.firstIndex(matching: card)!].matchState == .mismatched })
	}
	
	enum PickNumber {
		case first
		case second
		case third
		mutating func next() {
			switch self {
				case .first:
					self = .second
				case .second:
					self = .third
				case .third:
					self = .first
			}
		}
		mutating func previous() {
			switch self {
				case .first:
					self = .third
				case .second:
					self = .first
				case .third:
					self = .second
			}
		}
	}
	
	var currentPick: PickNumber = .first
	
	mutating func choose(card: Card) {
		
		
		
		
		
		if let chosenIndex: Int = cards.firstIndex(matching: card) {
			
			guard cards[chosenIndex].matchState != .matched else {
				return
			}
			
			if cards[chosenIndex].matchState == .selected {
				// case where the chosen card is already selected
				cards[chosenIndex].matchState = .none
				currentPick.previous()
			} else {
				// case where the chosen card is not already selected
				
				switch currentPick {
					
					case .first:
						
						
						if matchedCards.count == 3 {
							matchedCards.forEach { card in
								cards[cards.firstIndex(matching: card)!].matchState = .none
								cards[cards.firstIndex(matching: card)!].isMatched = true
								cards[cards.firstIndex(matching: card)!].isDiscarded = true
							}
							// set the chosen card to .selected
							cards[chosenIndex].matchState = .selected
							self.deal()
						}
												
						mismatchedCards.forEach({ card in
							cards[cards.firstIndex(matching: card)!].matchState = .none
						})
						
						cards[chosenIndex].matchState = .selected
												
					case .second:
												
						cards[chosenIndex].matchState = .selected
						
					case .third:
						
						// if the chosen card is a potential match
						if cards[chosenIndex].matchState == .potentialMatch {
							
							// first set the pick state to .selected
							cards[chosenIndex].matchState = .selected
							// then for all cards in selectedCards (i.e. with .selected matchState), set these cards to .matched
							for card in selectedCards {
								cards[cards.firstIndex(matching: card)!].matchState = .matched
							}
							
							
						// if the chosen card is not a match
						} else {
							// first set the match state to .selected
							cards[chosenIndex].matchState = .selected
							// then for all cards in selectedCards (i.e. with .selected pickState), set these cards to .mismatched
							for card in selectedCards {
								cards[cards.firstIndex(matching: card)!].matchState = .mismatched
							}
						}
						
				}
				currentPick.next()
			}
			self.determineSetPossibilities(of: selectedCards)
			
		}
		
	}
	
	mutating func determineSetPossibilities(of selectedCards: [Card]) {

		// Case where no cards are selected
		guard selectedCards.count > 0 else {
			cards.filter({card in
				card.matchState == .potentialMatch
			}).forEach({ card in
				cards[cards.firstIndex(matching: card)!].matchState = .none
			})
			return
		}
		
		var featureOneCollection = [FeaturePossibility]()
		var featureTwoCollection = [FeaturePossibility]()
		var featureThreeCollection = [FeaturePossibility]()
		var featureFourCollection = [FeaturePossibility]()
		
		for card in selectedCards {
			featureOneCollection.append(card.features[0])
			featureTwoCollection.append(card.features[1])
			featureThreeCollection.append(card.features[2])
			featureFourCollection.append(card.features[3])
		}
		
		if selectedCards.count == 1 {
			// Case where only one card has been selected
			for card in cards.filter({card in
				card.matchState != .selected
			}) {
				if featureOneCollection.allSatisfy( {feature in
					feature == card.features[0]
				}) || !featureOneCollection.contains(card.features[0]) {
					if featureTwoCollection.allSatisfy({ feature in
						feature == card.features[1]
					}) || !featureTwoCollection.contains(card.features[1]) {
						if featureThreeCollection.allSatisfy({ feature in
							feature == card.features[2]
						}) || !featureThreeCollection.contains(card.features[2]) {
							if featureFourCollection.allSatisfy({ feature in
								feature == card.features[3]
							}) || !featureFourCollection.contains(card.features[3]) {
								cards[cards.firstIndex(matching: card)!].matchState = .potentialMatch
							} else {
								cards[cards.firstIndex(matching: card)!].matchState = .none
							}
						} else {
							cards[cards.firstIndex(matching: card)!].matchState = .none
						}
					} else {
						cards[cards.firstIndex(matching: card)!].matchState = .none
					}
				} else {
					cards[cards.firstIndex(matching: card)!].matchState = .none
				}
			}
		} else {
			// Case where two cards have been selected. Here if first and second element of the collection of a feature of the selectedCards are equal, then a card is only considered a match if its given feature is also equal to the elements of that feature collection
			for card in cards.filter({card in
				card.matchState != .selected
			}) {
				if featureOneCollection[0] == featureOneCollection[1] ? featureOneCollection.allSatisfy( { feature in
				feature == card.features[0]	}) : featureOneCollection.allSatisfy( {feature in
					feature == card.features[0]
				}) || !featureOneCollection.contains(card.features[0]) {
					if featureTwoCollection[0] == featureTwoCollection[1] ? featureTwoCollection.allSatisfy({ feature in
					feature == card.features[1]
					}) : featureTwoCollection.allSatisfy({ feature in
						feature == card.features[1]
					}) || !featureTwoCollection.contains(card.features[1]) {
						if featureThreeCollection[0] == featureThreeCollection[1] ? featureThreeCollection.allSatisfy({ feature in
						feature == card.features[2]
						}) : featureThreeCollection.allSatisfy({ feature in
							feature == card.features[2]
						}) || !featureThreeCollection.contains(card.features[2]) {
							if featureFourCollection[0] == featureFourCollection[1] ? featureFourCollection.allSatisfy({ feature in
							feature == card.features[3]
							}) : featureFourCollection.allSatisfy({ feature in
								feature == card.features[3]
							}) || !featureFourCollection.contains(card.features[3]) {
								cards[cards.firstIndex(matching: card)!].matchState = .potentialMatch
							} else {
								cards[cards.firstIndex(matching: card)!].matchState = .none
							}
						} else {
							cards[cards.firstIndex(matching: card)!].matchState = .none
						}
					} else {
						cards[cards.firstIndex(matching: card)!].matchState = .none
					}
				} else {
					cards[cards.firstIndex(matching: card)!].matchState = .none
				}
			}
		}

	}
	
	
	
}



