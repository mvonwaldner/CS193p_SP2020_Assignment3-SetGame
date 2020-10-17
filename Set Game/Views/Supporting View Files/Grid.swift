//
//  Grid.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/18/20.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
	
	private var items: [Item] // an identifiable thing
	private var viewForItem: (Item) -> ItemView // a function that takes an identifiable and returns a View
	
	
	init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
		self.items = items
		self.viewForItem = viewForItem
	} // pass in the array of items and the function that returns them as a view
	
	var body: some View {
		GeometryReader { geometry in
			self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
		}
	} // self.body(for layout:), passing the geometry's size in as the 'in' parameter of the GridLayout initializer
	
	private func body(for layout: GridLayout) -> some View {
		ForEach(items) { item in
			self.body(for: item, in: layout)
		}
	} // takes the items and puts them into a foreach, with the closure that returns a view argument to ForEach being body(for:in:)
	// this is really returning a ForEach that uses the body(for:in:) function as a way to utilize the function value passed into the viewForItem part of the initializer
	
	private func body(for item: Item, in layout: GridLayout) -> some View {
		let index = items.firstIndex(matching: item)!
		
		return viewForItem(item)
			.frame(width: layout.itemSize.width, height: layout.itemSize.height)
			.position(layout.location(ofItemAt: index))
	}

	
//	func location(of item: Item, in layout: GridLayout) -> CGPoint {
//		return layout.location(ofItemAt: items.firstIndex(matching: item)!)
//	}

	
}
