//
//  ContentView.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/11/20.
//

import SwiftUI

struct ShapeSetGameView: View {
    
	@ObservedObject var viewModel: ShapeSetGame // pointer to VM
	
	var body: some View {
		GeometryReader { geometry in
			self.body(for: geometry.size)
		}
		
	}
	
	private func body(for size: CGSize) -> some View {
		
//		var positionOfDeck: CGRect
		
		return VStack {
			Text("SET").font(.largeTitle).bold()
			Divider()
			HStack {
				if viewModel.cards.filter({ card in
					card.wasDealt == false
				}).count != 0 {
					RoundedRectangle(cornerRadius: 2.5, style: .continuous)
					.fill()
					.foregroundColor(.orange)
					.frame(width: 40, height: 60, alignment: .center)
				}
				Spacer()
				Button(action: { withAnimation(.easeInOut, {viewModel.deal()} )  }, label: {
					Text("Deal")
				})
				.disabled(viewModel.cardsDealt.count == viewModel.cards.count)
			}
			.padding()
			Divider()
			GeometryReader { gridGeometry in
				Grid(viewModel.cardsFaceUp) { card in
					CardView(card: card)
						.transition(AnyTransition.offset(
										x: -(100 + GridLayout(itemCount: viewModel.cardsFaceUp.count, in: gridGeometry.size).location(ofItemAt:  viewModel.cardsFaceUp.firstIndex(matching: card)!).x),
										y: -GridLayout(itemCount: viewModel.cardsFaceUp.count, in: gridGeometry.size).location(ofItemAt: viewModel.cardsFaceUp.firstIndex(matching: card)!).y))
						.onTapGesture { withAnimation(.easeInOut(duration: 0.25), {viewModel.choose(card: card)} )}
				}
				.onAppear(perform: { withAnimation(.easeInOut, { viewModel.deal() } ) })
			}
			Divider()
			Button(action: { viewModel.restart() }, label: {
				 Text("New Game")
			})
			.padding()
		}
	}
	


}


struct CardView: View {
	
	var card: SetGame<ShapeSetGameCardFace>.Card
	
	var body: some View {
		ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
			RoundedRectangle(
				cornerRadius: 2.5,
				style: .continuous
			)
			.stroke(Color.orange)
			.overlay(vStackForShapes)
			.background(rectForShadow)
		}
		.foregroundColor(.white)
		.padding(.all, 3)
		.aspectRatio(2/3, contentMode: .fit)
	}
	
	var rectForShadow: some View { RoundedRectangle(
		cornerRadius: 2.5,
		style: .continuous
	)
	.fill()
	.foregroundColor(.white)
	.shadow(color: getShadowColor(), radius: 10)
	}
	
	var vStackForShapes: some View {
		VStack {
			ForEach(Range(1...card.visualContent.count)) { _ in
				card.visualContent.getShapeView(
					shapeType: card.visualContent.shape
				)
				.aspectRatio(1, contentMode: .fit)
			}
		}
		.padding(.all, 9)
	}
	
	func getShadowColor() -> Color {
		switch card.matchState {
			case .none:
				return .clear
			case .potentialMatch:
				return .gray
			case .selected:
				return .blue
			case .matched:
				return .green
			case .mismatched:
				return .red
		}
	}
	
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame()
		return ShapeSetGameView(viewModel: game)
    }
}
