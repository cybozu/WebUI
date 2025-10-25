import SwiftUI
import WebUI

struct ContentView: View {
    @StateObject var viewState = ContentViewState()

    var body: some View {
        WebViewReader { proxy in
            VStack {
                Text(proxy.displayedTitle)

                HStack {
                    Button {
                        proxy.goBack()
                    } label: {
                        Label("Go Back", systemImage: "arrow.backward")
                            .labelStyle(.iconOnly)
                    }
                    .disabled(!proxy.canGoBack)

                    Button {
                        proxy.goForward()
                    } label: {
                        Label("Go Forward", systemImage: "arrow.forward")
                            .labelStyle(.iconOnly)
                    }
                    .disabled(!proxy.canGoForward)

                    Spacer()

                    Button {
                        proxy.reload()
                    } label: {
                        Label("Reload", systemImage: "arrow.clockwise")
                            .labelStyle(.iconOnly)
                    }

                    Menu {
                        Button {
                            proxy.loadHTMLString(viewState.htmlString, baseURL: viewState.htmlURL)
                        } label: {
                            Label("Load HTML String", systemImage: "doc")
                        }

                        Button {
                            proxy.clearAll()
                            proxy.load(request: viewState.request)
                        } label: {
                            Label("Clear", systemImage: "clear")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                            .labelStyle(.iconOnly)
                    }
                }
                .padding(.vertical, 8)

                ProgressView(value: proxy.estimatedProgress)
                    .opacity(proxy.isLoading ? 1.0 : 0.1)

                WebView(configuration: viewState.configuration)
                    .uiDelegate(viewState)
                    .navigationDelegate(viewState)
                    .allowsInspectable(true)
                    .allowsBackForwardNavigationGestures(true)
                    .allowsLinkPreview(false)
                    .allowsOpaqueDrawing(false)
                    .refreshable()
                    .border(Color.gray)
            }
            .onAppear {
                proxy.load(request: viewState.request)
            }
        }
        .padding()
        .alert("", isPresented: $viewState.showDialog, presenting: viewState.webDialog) { webDialog in
            if case .prompt(_, let defaultText, _) = webDialog {
                TextField(defaultText, text: $viewState.promptInput)
            }
            Button {
                viewState.dialogOK()
            } label: {
                Text(verbatim: "OK")
            }
            if webDialog.needsCancel {
                Button(role: .cancel) {
                    viewState.dialogCancel()
                } label: {
                    Text(verbatim: "Cancel")
                }
            }
        } message: { webDialog in
            Text(webDialog.message)
        }
    }
}

private extension WebViewProxy {
    var displayedTitle: String {
        if let title, !title.isEmpty {
            title
        } else {
            " "
        }
    }
}

#Preview {
    ContentView()
}
