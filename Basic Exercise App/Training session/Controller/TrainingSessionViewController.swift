import UIKit

final class TrainingSessionViewController: UIViewController {

    private let orientationService: InterfaceOrientationService = TrainingScreenInterfaceOrientation()
    private let dataLoader: TrainingSessionDataLoader

    init(_ exerciseItems: [ExerciseItem]) {
        self.dataLoader = TrainingSessionDataLoader(exerciseItems: exerciseItems)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .magenta
        UIDevice.current.setValue(orientationService.interfaceOrientation.rawValue, forKey: "orientation")

        loadData()
    }

    private func loadData() {
        dataLoader.loadData()
    }
}

extension TrainingSessionViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientationService.supportedUIInterfaceOrientationMask
    }

    override var shouldAutorotate: Bool {
        orientationService.shouldAutorotate
    }
}
