import UIKit

final class TrainingSessionViewController: UIViewController {

    private let orientationService: InterfaceOrientationService = TrainingScreenInterfaceOrientation()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .magenta
        UIDevice.current.setValue(orientationService.interfaceOrientation.rawValue, forKey: "orientation")
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
