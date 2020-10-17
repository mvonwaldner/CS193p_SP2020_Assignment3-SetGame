//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Michael von Waldner on 9/11/20.
//

import SwiftUI

@main
struct Set_GameApp: App {
    var body: some Scene {
        WindowGroup {
			let game = ShapeSetGame()
			ShapeSetGameView(viewModel: game)
        }
    }
}
