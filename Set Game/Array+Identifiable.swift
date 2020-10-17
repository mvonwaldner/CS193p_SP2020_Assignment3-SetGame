//
//  Array+Identifiable.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/18/20.
//

import Foundation

extension Array where Element: Identifiable {
	func firstIndex(matching: Element) -> Int? {
		for index in 0..<self.count {
			if self[index].id == matching.id {
				return index // here the optional Int is returning the Int associated value when it is in the .some case
			}
		}
		return nil // optional Int lets us return nil
	}
}
