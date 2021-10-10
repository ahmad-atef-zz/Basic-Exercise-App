import XCTest
import Combine
@testable import Basic_Exercise_App

final class ExercisesRepositoryTests: XCTestCase {

    private var cancelable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancelable = []
    }

    func testLoadingExercisesSuccessfully() {
        // given
        let repository = MockExercisesRepository()
        let expectation = expectation(description: "Wait to load exercises")
        var exercises = [Exercise]()

        repository
            .loadExercises()
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { value in
                exercises = value
            }).store(in: &cancelable)

        // when
        repository
            .loadSuccessfully(withExercises: .moveHip, .sidePlank)
        repository.finish()

        /// then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(exercises, [.moveHip, .sidePlank])
    }

    func testLoadingExercisesUnSuccessfully() {
        // given
        let repository = MockExercisesRepository()
        let expectation = expectation(description: "Wait to load exercises")
        var exercises = [Exercise]()
        var error: Error?

        repository
            .loadExercises()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let receivedError):
                    error = receivedError
                }
                expectation.fulfill()
            }, receiveValue: { value in
                exercises = value
            }).store(in: &cancelable)

        // when
        repository.failToLoad()
        repository.finish()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(error)
        XCTAssertTrue(exercises.isEmpty)
    }
}

private final class MockExercisesRepository: ExercisesRepository {
    enum MockError: Error {
        case any
    }

    var publisher: AnyPublisher<[Exercise], Error> {
        subject.eraseToAnyPublisher()
    }

    private let subject = PassthroughSubject<[Exercise], Error>()

    func loadSuccessfully(withExercises exercises: Exercise...) {
        subject.send(exercises)
    }

    func failToLoad() {
        subject.send(completion: .failure(MockError.any))
    }

    func loadExercises() -> AnyPublisher<[Exercise], Error> {
        return publisher
    }

    func finish() {
        subject.send(completion: .finished)
    }

}
