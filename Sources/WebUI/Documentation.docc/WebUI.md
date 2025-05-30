# ``WebUI``

@Metadata {
    @PageImage(purpose: icon,
               source: "logo",
               alt: "A icon representing the WebUI package.")
    @PageColor(blue)
}

WebUI is a Swift Package for building WebView in SwiftUI. It wraps WKWebView and provides a simple API to load a URL or HTML string.

## Additional Resources

- [GitHub Repository](https://github.com/cybozu/WebUI)

## Overview

This package provides a WebView component for SwiftUI. Building a WebView in SwiftUI is not straightforward because `WKWebView` has many instance methods to manipulate the web view. `WebUI` resolves instance method calls through proxy objects.
