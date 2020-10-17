//
//  Diamond.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/15/20.
//

import SwiftUI

struct Diamond: Shape {
	
	func path(in rect: CGRect) -> Path {
		
		/// The center of the containing rect space
		let center = CGPoint(x: rect.midX, y: rect.midY)
		
		/// Separate variables for the width and height of the containing rect space
		let width = rect.width
		let height = width / 2
		
		/// Points of the diamond
		let start = CGPoint(x: center.x, y: center.y + height/2)
		let maxX = CGPoint(x: width, y: center.y)
		let minY = CGPoint(x: center.x, y: center.y - height/2)
		let minX = CGPoint(x: 0, y: center.y)
		
		/// The path of the diamond
		var p = Path()
		p.move(to: start)
		p.addLine(to: maxX)
		p.addLine(to: minY)
		p.addLine(to: minX)
		p.closeSubpath()
		return p
		
	}
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
    }
}
