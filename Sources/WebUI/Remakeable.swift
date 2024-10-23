#if canImport(UIKit)
import UIKit
typealias OSView = UIView
#elseif canImport(AppKit)
import AppKit
typealias OSView = NSView
#endif

final class Remakeable<Content: OSView>: OSView {
    private(set) var wrappedValue: Content {
        didSet {
            action?(wrappedValue)
        }
    }
    private let content: () -> Content
    private var action: ((Content) -> Void)?

    init(content: @escaping () -> Content) {
        self.content = content
        wrappedValue = content()
        super.init(frame: .zero)
        addSubview(wrappedValue)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func remake() {
        wrappedValue.removeFromSuperview()
        wrappedValue = content()
        addSubview(wrappedValue)
        setConstraints()
    }

    func onRemake(perform action: @escaping (Content) -> Void) {
        self.action = action
    }

    private func setConstraints() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        wrappedValue.topAnchor.constraint(equalTo: topAnchor).isActive = true
        wrappedValue.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        wrappedValue.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        wrappedValue.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
