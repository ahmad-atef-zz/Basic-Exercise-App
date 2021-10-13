import UIKit
import Combine

final class ExercisesListViewController: UIViewController {

    private var cancellable: Set<AnyCancellable> = []
    private let dataLoader: ExerciseDataLoader = ExerciseDataLoader()
    private var collectionView: UICollectionView!
    private var exerciseCellRegistration: UICollectionView.CellRegistration<ExerciseCell, ExerciseItem>!
    private var loadingIndicator: UIActivityIndicatorView!
    private let behaviour = ExerciseListItemBehaviour()
    private let orientationService: InterfaceOrientationService = ListScreenInterfaceOrientation()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.title = "Exercise Overview 🏋️"

        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)

        setUpCollectionView()
        setUpStartExerciseButton()
        fetchData()
    }

    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: .list)
        collectionView.backgroundColor = .systemGray
        collectionView.contentInset.bottom = 50
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        exerciseCellRegistration = UICollectionView.CellRegistration { cell, indexPath, exerciseItem in
            cell.apply(.init(exerciseItem))
            cell.delegate = self
        }
        collectionView.register(ExerciseCell.self, forCellWithReuseIdentifier: ExerciseCell.reuseIdentifier)
    }

    private func setUpStartExerciseButton() {
        let button = UIButton()
        button.setTitle("Start training 💪", for: .normal)
        button.backgroundColor = .systemOrange
        button.addTarget(self, action: #selector(didTapStartExercise), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    @objc func didTapStartExercise() {
        let trainingSessionViewController = TrainingSessionViewController(dataLoader.exerciseItems)
        //self.present(trainingSessionViewController, animated: true)
        self.navigationController?.pushViewController(trainingSessionViewController, animated: true)
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

extension ExercisesListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataLoader.exerciseItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exerciseItem = dataLoader.exerciseItems[indexPath.row]
        return collectionView.dequeueConfiguredReusableCell(using: exerciseCellRegistration, for: indexPath, item: exerciseItem)
    }

}


extension ExercisesListViewController: ExerciseCellDelegate {
    func exerciseListCellDidChangeFavorite(_ cell: ExerciseCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let exerciseItem = dataLoader.exerciseItems[indexPath.row]
        behaviour.toggleFavorite.perform(exerciseItem: exerciseItem)
    }
}

extension ExercisesListViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientationService.supportedUIInterfaceOrientationMask
    }
}
