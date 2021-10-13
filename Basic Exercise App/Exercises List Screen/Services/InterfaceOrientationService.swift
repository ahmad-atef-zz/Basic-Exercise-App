import UIKit

protocol InterfaceOrientationService {
    var supportedUIInterfaceOrientationMask: UIInterfaceOrientationMask { get }
    var interfaceOrientation: UIInterfaceOrientation { get }
    var shouldAutorotate: Bool { get }
}

extension InterfaceOrientationService {
    var interfaceOrientation: UIInterfaceOrientation {
        .portrait
    }

    var shouldAutorotate: Bool {
        true
    }
}

final class ListScreenInterfaceOrientation: InterfaceOrientationService {
    var supportedUIInterfaceOrientationMask: UIInterfaceOrientationMask {
        .all
    }
}


final class TrainingScreenInterfaceOrientation: InterfaceOrientationService {
    var supportedUIInterfaceOrientationMask: UIInterfaceOrientationMask {
        .landscape
    }

    var interfaceOrientation: UIInterfaceOrientation {
        .landscapeLeft
    }
}
