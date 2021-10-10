import Foundation
import Combine

protocol ExerciseDataSource {
    var isLoading: Bool { get set}
    func loadData()
}


final class ExerciseDataLoader: ExerciseDataSource {

    private let favoriteService: FavoriteService
    private let exercisesRepository: ExercisesRepository
    private var cancellable = Set<AnyCancellable>()

    @Published
    internal var isLoading: Bool = false

    init(
        favoriteService: FavoriteService = LocalFavoriteService.default,
        exercisesRepository: ExercisesRepository = RemoteExercisesRepository()
    )
    {
        self.favoriteService = favoriteService
        self.exercisesRepository = exercisesRepository
    }

    func loadData() {
        isLoading = true
        let exercisesPublisher = exercisesRepository
            .loadExercises()
            .catch { error -> AnyPublisher<[Exercise], Never> in
                print("Error loading exercises \(error)")
                return Just([])
                    .eraseToAnyPublisher()
            }

        let favoritesPublisher = favoriteService
            .loadFavorites()
            .catch { error -> AnyPublisher<[Exercise], Never> in
                print("Error loading favorites \(error)")
                return Just([])
                    .eraseToAnyPublisher()
            }

        Publishers.CombineLatest(exercisesPublisher, favoritesPublisher)
            .receive(
                on: DispatchQueue.main)
            .sink(
                receiveValue: { value in
                    self.isLoading = false
                })
            .store(in: &cancellable)
    }
}
