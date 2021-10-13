//
//  TrainingSessionDataLoader.swift
//  Basic Exercise App
//
//  Created by Ahmed Atef Ali Ahmed on 13.10.21.
//

import Foundation
import Combine

final class TrainingSessionDataLoader {

    private let exerciseItems: [ExerciseItem]
    private let exerciseSwitcher: ExerciseSwitcher

    private var cancellable = Set<AnyCancellable>()

    init(
        exerciseItems: [ExerciseItem],
        exerciseSwitcher: ExerciseSwitcher = FiveSecondsExerciseSwitcher()
    ) {
        self.exerciseItems = exerciseItems
        self.exerciseSwitcher = exerciseSwitcher
    }

    func loadData() {

        Timer
            .publish(
                every: exerciseSwitcher.exerciseTime,
                on: .main,
                in: .default
            )
            .sink(
                receiveCompletion: { completion in

                }, receiveValue: { value in

                }
            )
            .store(in: &cancellable)
    }
}
