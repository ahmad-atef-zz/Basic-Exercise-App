import UIKit

final class TrainingSessionViewController: UIViewController {

    private let orientationService: InterfaceOrientationService = TrainingScreenInterfaceOrientation()
    private let dataLoader: TrainingSessionDataLoader
    private var currentExerciseImageView: RemoteImageView!

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

        setupTrainingImageView()
        setUpFavoriteExerciseButton()
        setUpCancelTrainingButton()
        // loadData()

        currentExerciseImageView.loadImage(fromURL: .init(string: "https://d32oopmphic0po.cloudfront.net/v1/images/body/en-US/body-exercise-4-14.png")!)
    }

    private func loadData() {
        dataLoader.loadData()
    }

    private func setupTrainingImageView() {
        currentExerciseImageView = RemoteImageView()
        currentExerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentExerciseImageView)

        NSLayoutConstraint.activate([
            currentExerciseImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currentExerciseImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currentExerciseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentExerciseImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setUpFavoriteExerciseButton() {
        let button = UIButton()
        button.setTitle("Favorite Exercise 🤩", for: .normal)
        button.backgroundColor = .systemTeal
        button.addTarget(self, action: #selector(didTapFavoriteExercise), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    private func setUpCancelTrainingButton() {
        let button = UIButton()
        button.setTitle("Cancel training 😪", for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(didTapCancelTraining), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    @objc func didTapFavoriteExercise() {

    }

    @objc func didTapCancelTraining() {
        self.navigationController?.popViewController(animated: true)
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
