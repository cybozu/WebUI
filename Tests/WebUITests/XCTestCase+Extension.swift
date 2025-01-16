import XCTest

extension XCTestCase {
    func weaklyScope<T: AnyObject>(
        _ instance: @autoclosure () -> T,
        perform action: (T) -> ()
    ) -> T? {
        weak var weakValue = {
            let value = instance()
            action(value)
            return value
        }()
        return weakValue
    }
}
