import XCTest
import Combine
@testable import Basic_Exercise_App

class FavoriteServiceTests: XCTestCase {

    private var cancelable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancelable = []
    }

    func testAddingToService() {
        // given
        let service = MockFavoriteService()
        let expectation = expectation(description: "wait for loading favorites")
        var loadedExercises = [Exercise]()

        service
            .loadFavorites()
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { value in
                loadedExercises = value
            })
            .store(in: &cancelable)


        // when
        service.add(exercise: .moveHip)
        service.finish()

        wait(for: [expectation], timeout: 1.0)

        // then
        XCTAssertEqual(loadedExercises, [.moveHip])
    }

    func testRemovingFromService() {
        // given
        let service = MockFavoriteService()
        let expectation = expectation(description: "wait for loading favorites")
        var loadedExercises = [Exercise]()

        service
            .loadFavorites()
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { value in
                loadedExercises = value
            })
            .store(in: &cancelable)

        // when
        service.add(exercise: .moveHip)
        service.remove(exercise: .moveHip)
        service.finish()

        wait(for: [expectation], timeout: 1.0)

        // then
        XCTAssertTrue(loadedExercises.isEmpty)
    }
}

private final class MockFavoriteService: FavoriteService {

    var publisher: AnyPublisher<[Exercise], Never> {
        subject.eraseToAnyPublisher()
    }

    private let subject = PassthroughSubject<[Exercise], Never>()
    private var exercises = [Exercise]() {
        didSet {
            subject.send(exercises)
        }
    }

    func add(exercise: Exercise) {
        exercises.append(exercise)
    }

    func remove(exercise: Exercise) {
        exercises.remove(object: exercise)
    }

    func finish() {
        subject.send(completion: .finished)
    }

    func loadFavorites() -> AnyPublisher<[Exercise], Never> {
        publisher
    }
}
