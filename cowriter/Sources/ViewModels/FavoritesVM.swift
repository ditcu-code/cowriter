//
//  FavoritesVM.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 11/05/23.
//

import Foundation

class FavoritesVM: ObservableObject {
    @Published var allFavorites: [Message]?
    
    init() {
        getAllFavorites()
    }
    
    func getAllFavorites() {
        allFavorites = Message.getFavoritesMessage()
    }
}
