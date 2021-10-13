import UIKit

protocol InterfaceOrientationService {
    var supportedInterfaceOrientations: UIInterfaceOrientationMask { get }
}

final class ListScreenInterfaceOrientation: InterfaceOrientationService {
    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }
}


final class TrainingScreenInterfaceOrientation: InterfaceOrientationService {
    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
}
