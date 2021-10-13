import UIKit
import Combine

final class RemoteImageView: UIImageView {
    private var cancelable = Set<AnyCancellable>()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        preconditionFailure()
    }


    func loadImage(fromURL url: URL) {
        image = nil

        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .map(UIImage.init)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &cancelable)

    }
}
