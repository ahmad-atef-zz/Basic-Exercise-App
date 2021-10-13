//
//  TrainingSessionBehaviours.swift
//  Basic Exercise App
//
//  Created by Ahmed Atef Ali Ahmed on 13.10.21.
//

import Foundation

final class TrainingSessionBehaviours {
    let favoriteBehaviour: ToggleFavoriteBehaviour

    init (favoriteBehaviour: ToggleFavoriteBehaviour = ToggleFavoriteBehaviour()) {
        self.favoriteBehaviour = favoriteBehaviour
    }
}
