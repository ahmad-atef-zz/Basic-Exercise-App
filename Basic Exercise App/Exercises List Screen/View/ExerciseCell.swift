import UIKit

protocol ExerciseCellDelegate: AnyObject {
    func exerciseListCellDidChangeFavorite(_ cell: ExerciseCell)
}

final class ExerciseCell: UICollectionViewCell {
    static let reuseIdentifier = "ExerciseCell"
    weak var delegate: ExerciseCellDelegate?

    struct ViewModel {
        let exerciseName: String
        let exerciseImageURL: URL
        let favoriteButtonImage: UIImage?

        init(_ exerciseItem: ExerciseItem) {
            self.exerciseName = exerciseItem.exercise.name
            self.exerciseImageURL = URL(string: exerciseItem.exercise.coverImageUrl)!
            self.favoriteButtonImage = exerciseItem.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let coverImage: RemoteImageView = {
        let imageView = RemoteImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .light)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.backgroundColor = .systemYellow
        return button
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 8.0
        return stackView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)

        horizontalStackView.addArrangedSubviews(coverImage, titleLabel, favoriteButton)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverImage.widthAnchor.constraint(equalToConstant: 150.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50.0),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    func apply(_ viewModel: ViewModel) {
        titleLabel.text = viewModel.exerciseName
        coverImage.loadImage(fromURL: viewModel.exerciseImageURL)
        favoriteButton.setImage(viewModel.favoriteButtonImage, for: .normal)
    }

    @objc
    func didTapFavorite() {
        delegate?.exerciseListCellDidChangeFavorite(self)
    }

}


private extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
