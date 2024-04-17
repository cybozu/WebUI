import Combine

extension Publisher where Self.Failure == Never {
    /// This is a workaround for the AsyncPublisher issue of WKWebView properties.
    func bufferedValues() -> AsyncPublisher<Publishers.Buffer<Self>> {
        self.buffer(size: 3, prefetch: .keepFull, whenFull: .dropOldest)
            .values
    }
}
