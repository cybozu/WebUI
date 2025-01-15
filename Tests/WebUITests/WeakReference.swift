final class WeakReference<T> where T : AnyObject {
    weak var value: T?

    func bypass(_ value: T) -> T {
        self.value = value
        return value
    }
}
