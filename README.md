# WebUI

WebUI is a Swift package that provides WKWebView wrapped by SwiftUI.

## Requirements

- Development with Xcode 15.1+
- Written in Swift 5.9
- swift-tools-version: 5.9
- Compatible with iOS 16.4+
- Compatible with macOS 13.3+

## Documentation

[Latest (Swift DocC)](https://cybozu.github.io/WebUI/documentation/webui/)

## Usage

```swift
struct ContentView: View {
    var body: some View {
        WebViewReader { proxy in
            WebView()
                .onAppear {
                    proxy.load(url: URL(string: "https://www.example.com")!)
                }
        }
        .padding()
    }
}
```
