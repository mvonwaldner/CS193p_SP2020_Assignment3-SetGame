//
//  ShapeSetGame.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/15/20.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
	@Published private var model: SetGame<ShapeSetGameCardFace> = ShapeSetGame.createMemoryGame()

	private static func createMemoryGame() -> SetGame<ShapeSetGameCardFace> {
		
		return SetGame<ShapeSetGameCardFace>(
			visualCardContentFactory: { (shapePossibility, countPossibility, colorPossibility, opacityPossibility) in
				return ShapeSetGameCardFace(
				
					shape: shapePossibility,
					count: countPossibility,
					color: opacityPossibility,
					opacity: colorPossibility
	
				)
			}
		)
	}
	
	// MARK: - Access to the Model
	
	var cards: Array<SetGame<ShapeSetGameCardFace>.Card> {
		model.cards
	}
	
	var cardsDealt: Array<SetGame<ShapeSetGameCardFace>.Card> {
		model.cards.filter { card in
			card.wasDealt == true
		}
	}
	
	var cardsFaceUp: Array<SetGame<ShapeSetGameCardFace>.Card> {
		model.cards.filter { card in
			card.wasDealt == true && card.isDiscarded == false
		}
	}
	
	var selectedCards: Array<SetGame<ShapeSetGameCardFace>.Card> {
		model.cards.filter({ card in cards[cards.firstIndex(matching: card)!].matchState == .selected })
	}
	
	// MARK: - Intent(s)
	
	func deal() {
		model.deal()
	}
	
	func restart() {
		withAnimation(Animation.easeInOut) { model = ShapeSetGame.createMemoryGame() }
		withAnimation(Animation.easeInOut) { model.deal() }
	}
	
	func choose(card: SetGame<ShapeSetGameCardFace>.Card) {
		model.choose(card: card)
	}

}


/// A specific card face's visual contents
struct ShapeSetGameCardFace {
	
	/// a card face's shape type
	let shape: ShapeType
	/// a card face's shape count
	let count: Int
	/// the color of the shape(s) on a card face
	let color: Color
	/// the opacity of the shape(s) on a card face
	let opacity: Double

	init(
		shape: SetGame<ShapeSetGameCardFace>.FeaturePossibility,
		count: SetGame<ShapeSetGameCardFace>.FeaturePossibility,
		color: SetGame<ShapeSetGameCardFace>.FeaturePossibility,
		opacity: SetGame<ShapeSetGameCardFace>.FeaturePossibility
		) {
		switch shape {
			case .one:
				self.shape = .diamond
			case .two:
				self.shape = .rectangle
			case .three:
				self.shape = .circle
		}
		switch count {
			case .one:
				self.count = 1
			case .two:
				self.count = 2
			case .three:
				self.count = 3
		}
		switch opacity {
			case .one:
				self.opacity = 0.0
			case .two:
				self.opacity = 0.5
			case .three:
				self.opacity = 1.0
		}
		switch color {
			case .one:
				self.color = .red
			case .two:
				self.color = .green
			case .three:
				self.color = .purple
		}
	}
	
	enum ShapeType: CaseIterable {
		case circle
		case rectangle
		case diamond
	}
	
	/// Utility function for getting the shape View of each ShapeType case in the form of
	/// a ZStack
	func getShapeView(shapeType: ShapeType) -> some View {
		ZStack {
			switch shapeType {
			case .circle:
				Circle().stroke()
				Circle().fill().opacity(self.opacity)
			case .rectangle:
				Rectangle().stroke()
				Rectangle().fill().opacity(self.opacity)
			case .diamond:
				Diamond().stroke()
				Diamond().fill().opacity(self.opacity)
			}
			
		}
		.foregroundColor(self.color)
	}
	
	
	
	
}
















