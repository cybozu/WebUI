<picture>
  <source srcset="https://github.com/user-attachments/assets/7bfa24f4-e7d5-4a38-84b9-b1d06fee0067" media="(prefers-color-scheme: dark)" alt="WebUI by Cybozu">
  <img src="https://github.com/user-attachments/assets/4f98afdc-b68b-476b-85ce-a3dc428665ef" alt="WebUI by Cybozu">
</picture>

WebUI is a Swift package that provides WKWebView wrapped by SwiftUI.

[![Github forks](https://img.shields.io/github/forks/cybozu/WebUI)](https://github.com/cybozu/WebUI/network/members)
[![Github stars](https://img.shields.io/github/stars/cybozu/WebUI)](https://github.com/cybozu/WebUI/stargazers)
[![Github issues](https://img.shields.io/github/issues/cybozu/WebUI)](https://github.com/cybozu/WebUI/issues)
[![Github release](https://img.shields.io/github/v/release/cybozu/WebUI)](https://github.com/cybozu/WebUI/releases)
[![Github license](https://img.shields.io/github/license/cybozu/WebUI)](https://github.com/cybozu/WebUI/blob/main/LICENSE)

## Requirements

- Development with Xcode 16.2+
- Written in Swift 6.0
- Compatible with iOS 16.4+
- Compatible with macOS 13.3+

> [!NOTE]
> Xcode 16.4 has a bug where it cannot resolve the path for `libswiftWebKit.dylib` in the iOS Simulator.  
> A workaround is required to run apps in the iOS Simulator. Please see the release notes for details.  
> ref: https://developer.apple.com/forums/thread/785964

## Usage

Using `WebUI`, you can build a WebView in `SwiftUI` with simple APIs.

For more in-depth infomation, see [API Documentation](https://cybozu.github.io/WebUI/documentation/webui/).

### Display Web Page

Use `WebView(request:)`.

```swift
struct ContentView: View {
    var body: some View {
        WebView(request: URLRequest(url: URL(string: "https://example.com/")!))
    }
}
```

### Manipulating WebView

Use `WebViewReader`.Within the scope of `WebViewReader`, you can receive `WebViewProxy`.  
You can manipulate `WebView` within the scope of `WebViewReader` via `WebViewProxy`.

```swift
struct ContentView: View {
    var body: some View {
        WebViewReader { proxy in
            WebView()
                .onAppear {
                    proxy.load(request: URLRequest(url: URL(string: "https://www.example.com")!))
                }

            Button("Reload") {
                proxy.reload()
            }
        }
        .padding()
    }
}
```

### Customizing WebView

Use `WebView(configuration:)`.

```swift
struct ContentView: View {
    let configuration: WKWebViewConfiguration

    init() {
        configuration = .init()
        configuration.allowsInlineMediaPlayback = true
    }

    var body: some View {
        WebView(configuration: configuration)
    }
}
```

Other useful APIs are available.

```swift
struct ContentView: View {
    var body: some View {
        WebView()
            .allowsLinkPreview(true)
            .refreshable()
    }
}
```

### Using with Delegates

Use `uiDelegate(_:)`, `navigationDelegate(_:)` method.

```swift
final class MyUIDelegate: NSObject, WKUIDelegate {}

final class MyNavigationDelegate: NSObject, WKNavigationDelegate {}

struct ContentView: View {
    var body: some View {
        WebView()
            .uiDelegate(MyUIDelegate())
            .navigationDelegate(MyNavigationDelegate())
    }
}
```

## Documentation

[Latest (Swift-DocC)](https://cybozu.github.io/WebUI/documentation/webui/)

## Installation

WebUI is available through [Swift Package Manager](https://github.com/apple/swift-package-manager/).

**Xcode**

1. File > Add Package Dependencies…
2. Search `https://github.com/cybozu/WebUI.git`.  
   <img src="https://github.com/user-attachments/assets/d332f31c-7cf8-42ba-9992-50a93110570b" width="800px">
3. Add package and link `WebUI` to your application target.  
   <img src="https://github.com/user-attachments/assets/df726717-6ecc-4921-9997-1799e05927fc" width="600px">

**CLI**

1. Create `Package.swift` that describes dependencies.

   ```swift
   // swift-tools-version: 6.0
   import PackageDescription

   let package = Package(
       name: "SomeProduct",
       products: [
           .library(name: "SomeProduct", targets: ["SomeProduct"])
       ],
       dependencies: [
           .package(url: "https://github.com/cybozu/WebUI.git", exact: "3.0.0")
       ],
       targets: [
           .target(
               name: "SomeProduct",
               dependencies: [
                   .product(name: "WebUI", package: "WebUI")
               ]
           )
       ]
   )
   ```

2. Run the following command in Terminal.
   ```sh
   $ swift package resolve
   ```

## Privacy Manifest

This library does not collect or track user information, so it does not include a PrivacyInfo.xcprivacy file.

## Contributing to WebUI

Contributions to WebUI are welcomed and encouraged! Please see the [Contributing Guide](/CONTRIBUTING.md).

## Demo

This repository includes demonstration app for iOS & macOS.

Open [Examples/Examples.xcodeproj](/Examples/Examples.xcodeproj) and Run it.
