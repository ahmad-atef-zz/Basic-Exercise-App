import Foundation
import Combine

protocol FavoriteService {
    func add(exercise: Exercise)
    func remove(exercise: Exercise)
    func loadFavorites() -> AnyPublisher<[Exercise], Never>
}

protocol DataPersistency {
    func set(_ value: Any?, forKey defaultName: String)
    func array(forKey defaultName: String) -> [Any]?
}

extension UserDefaults: DataPersistency {}

final class LocalFavoriteService: FavoriteService {

    static let `default` = LocalFavoriteService(UserDefaults.standard)

    var favoritesPublisher: AnyPublisher<[Exercise], Never> {
        favoritesSubject.eraseToAnyPublisher()
    }

    private var favoritesSubject = PassthroughSubject<[Exercise], Never>()
    private var favoriteExercisesList: [Exercise] {
        get {
            guard let favoriteList = dataPersistency.array(forKey: favoritesUserDefaultsKey) as? [Exercise] else { return [] }
            return favoriteList
        }
        set {
            favoritesSubject.send(newValue)
        }
    }
    private let dataPersistency: DataPersistency
    
    init(_ dataPersistency: DataPersistency) {
        self.dataPersistency = dataPersistency
    }

    func add(exercise: Exercise) {
        favoriteExercisesList.append(exercise)
        dataPersistency.set(favoriteExercisesList, forKey: favoritesUserDefaultsKey)
    }

    func remove(exercise: Exercise) {
        favoriteExercisesList.remove(object: exercise)
        dataPersistency.set(favoriteExercisesList, forKey: favoritesUserDefaultsKey)
    }

    func loadFavorites() -> AnyPublisher<[Exercise], Never> {
        favoritesPublisher
    }
}

extension LocalFavoriteService {
    private var favoritesUserDefaultsKey: String { "FavoriteService.List" }
}
