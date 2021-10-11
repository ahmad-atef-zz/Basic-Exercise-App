import UIKit

final class ExerciseCell: UICollectionViewCell {
    static let reuseIdentifier = "ExerciseCell"

    struct ViewModel {
        let exerciseName: String
        let exerciseImageURL: URL
        let isFavorite: Bool
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 55),
        ])
        return imageView
    }()
    private let favoriteStatusButton = UIButton()
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        horizontalStackView.addSubviews(coverImage, titleLabel, favoriteStatusButton)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    func apply(_ viewModel: ViewModel) {
        titleLabel.text = viewModel.exerciseName
    }

}

private extension UIStackView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
