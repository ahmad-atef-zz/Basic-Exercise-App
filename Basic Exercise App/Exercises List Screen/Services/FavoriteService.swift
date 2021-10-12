import Foundation
import Combine

protocol FavoriteService {
    func add(exercise: Exercise)
    func remove(exercise: Exercise)
    func loadFavorites() -> AnyPublisher<[Exercise], Error>
}

protocol DataPersistency {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: DataPersistency {}

final class LocalFavoriteService: FavoriteService {

    static let `default` = LocalFavoriteService(UserDefaults.standard)

    var favoritesPublisher: AnyPublisher<[Exercise], Error> {
        favoritesSubject.eraseToAnyPublisher()
    }
    private lazy var favoritesSubject = CurrentValueSubject<[Exercise], Error>(favoriteExercisesList)
    private var favoriteExercisesList: [Exercise] {

        get {
            guard let data = dataPersistency.data(forKey: favoritesUserDefaultsKey) else { return [] }
            do {
                let favorites = try decoder.decode([Exercise].self, from: data)
                return favorites
            } catch  {
                print("Unable to decode Array of favorites with error: \(error)")
            }
            return []
        }

        set {
            favoritesSubject.send(newValue)
            do {
                let data = try encoder.encode(newValue)
                dataPersistency.set(data, forKey: favoritesUserDefaultsKey)
            } catch {
                print("Unable to encode Array of favorites \(newValue) with error: \(error)")
            }
        }
    }

    private let dataPersistency: DataPersistency
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(_ dataPersistency: DataPersistency) {
        self.dataPersistency = dataPersistency
    }

    func add(exercise: Exercise) {
        favoriteExercisesList.append(exercise)
    }

    func remove(exercise: Exercise) {
        favoriteExercisesList.remove(object: exercise)
    }

    func loadFavorites() -> AnyPublisher<[Exercise], Error> {

        favoritesPublisher
    }
}

extension LocalFavoriteService {
    private var favoritesUserDefaultsKey: String { "FavoriteService.List" }
}
