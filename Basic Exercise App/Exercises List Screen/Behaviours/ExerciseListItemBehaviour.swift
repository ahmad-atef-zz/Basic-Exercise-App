//
//  ExerciseListItemBehaviour.swift
//  Basic Exercise App
//
//  Created by Ahmed Atef Ali Ahmed on 13.10.21.
//

import Foundation

final class ExerciseListItemBehaviour {
    // Other behaviours goes here...
    let toggleFavorite = ToggleFavoriteBehaviour()
}


final class ToggleFavoriteBehaviour {
    private let favoriteService: FavoriteService

    init(favoriteService: FavoriteService = LocalFavoriteService.default) {
        self.favoriteService = favoriteService
    }

    func perform(exerciseItem: ExerciseItem) {
        if exerciseItem.isFavorited {
            favoriteService.remove(exercise: exerciseItem.exercise)
        } else {
            favoriteService.add(exercise: exerciseItem.exercise)
        }
    }
}
