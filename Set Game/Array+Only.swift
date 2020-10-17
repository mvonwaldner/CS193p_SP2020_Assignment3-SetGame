//
//  Array+Only.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/18/20.
//

import Foundation

extension Array {
	var only: Element? {
		count == 1 ? first: nil
	}
}
