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

    @Published
    var didCompleteSession: Bool = false
    var currentExercisePublisher: AnyPublisher<ExerciseItem?, Never> {
        currentExerciseSubject.eraseToAnyPublisher()
    }
    private lazy var currentExerciseSubject = CurrentValueSubject<ExerciseItem?, Never>(currentExercise)
    private(set) var currentExercise: ExerciseItem? {
        didSet {
            currentExerciseSubject.send(currentExercise)
        }
    }

    private var currentIndex: Int = 0 {
        didSet {
            guard currentIndex < exerciseItems.count else { return }
            currentExercise = exerciseItems[currentIndex]
        }
    }

    init(
        exerciseItems: [ExerciseItem],
        exerciseSwitcher: ExerciseSwitcher = FiveSecondsExerciseSwitcher()
    ) {
        self.exerciseItems = exerciseItems
        self.exerciseSwitcher = exerciseSwitcher
    }

    func loadData() {
        Timer.publish(
            every: exerciseSwitcher.exerciseTime,
            on: .main,
            in: .default
        )
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.currentIndex += 1
                self.didCompleteSession = self.currentIndex >= self.exerciseItems.count
            })
            .store(in: &cancellable)
        currentIndex = 0
    }
}
