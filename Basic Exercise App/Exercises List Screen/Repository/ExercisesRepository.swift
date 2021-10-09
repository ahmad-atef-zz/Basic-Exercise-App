import Foundation
import Combine

protocol ExercisesRepository {
    func loadExercises() -> AnyPublisher<[Exercise], Error>
}

final class RemoteExercisesRepository: ExercisesRepository {

    private let session: URLSession
    private let baseURL = URL(string: "https://jsonblob.com/api/jsonBlob/")!
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadExercises() -> AnyPublisher<[Exercise], Error> {
        let url = baseURL.appendingPathExtension("027787de-c76e-11eb-ae0a-39a1b8479ec2")
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Exercise].self, decoder: decoder)
            .eraseToAnyPublisher()
    }

}
