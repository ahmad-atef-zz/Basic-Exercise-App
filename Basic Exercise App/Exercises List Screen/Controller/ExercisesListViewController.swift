import UIKit
import Combine

final class ExercisesListViewController: UIViewController {

    private let dataLoader: ExerciseDataLoader = ExerciseDataLoader()
    private var cancellable: Set<AnyCancellable> = []
    private var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        return loadingIndicator
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.title = "Exercise Overview 🏋️"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)

        fetchData()
    }

    private func fetchData() {
        dataLoader.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellable)

        dataLoader.dataChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellable)

        dataLoader.loadData()
    }
}
