import Foundation

protocol ExerciseSwitcher {
    var exerciseTime: TimeInterval { get }
}

final class FiveSecondsExerciseSwitcher: ExerciseSwitcher {
    var exerciseTime: TimeInterval {
        5.0
    }
}
