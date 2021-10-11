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
    private var exercises = [Exercise]()

    private(set) var dataChanged = PassthroughSubject<Void, Never>()

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
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.isLoading = false
                self.exercises = value.0
                self.dataChanged.send()
            })
            .store(in: &cancellable)
    }
}
