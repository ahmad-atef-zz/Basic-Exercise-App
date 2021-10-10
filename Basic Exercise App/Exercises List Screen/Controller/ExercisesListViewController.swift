import UIKit
import Combine

class ExercisesListViewController: UIViewController {

    private let dataSource: ExerciseDataSource
    private var cancellable: Set<AnyCancellable> = []

    init(_ dataSource: ExerciseDataSource = ExerciseDataLoader()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Exercise Overview 🏋️"
        dataSource.loadData()
    }

