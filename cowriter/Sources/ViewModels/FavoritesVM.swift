//
//  FavoritesVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 11/05/23.
//

import Foundation

class FavoritesVM: ObservableObject {
    @Published var allFavorites: [ResultType]?
    
    init() {
        getAllFavorites()
    }
    
    func getAllFavorites() {
        allFavorites = ResultType.getFavoritesResult()
    }
}
