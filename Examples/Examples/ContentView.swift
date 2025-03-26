import SwiftUI
import WebUI
import PDFKit

struct ContentView: View {
    @StateObject var viewState = ContentViewState()

    @State var pdf: PDFDocument?

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
                    Button {
                        proxy.clearAll()
                        proxy.load(request: viewState.request)
                    } label: {
                        Label("Clear", systemImage: "clear")
                            .labelStyle(.iconOnly)
                    }
                    Button {
                        proxy.loadHTMLString(viewState.htmlString, baseURL: viewState.htmlURL)
                    } label: {
                        Label("Load HTML String", systemImage: "doc")
                            .labelStyle(.iconOnly)
                    }

                    Button {
                        Task {
                            pdf = PDFDocument(data: try! await proxy.contentReader.pdf())
                        }
                    } label: {
                        Label("Take PDF", systemImage: "printer")
                            .labelStyle(.iconOnly)
                    }
                    .accessibilityIdentifier("take_pdf_button")

                    if let pdf = pdf {
                        ShareLink(item: pdf,
                                  preview: SharePreview("PDF Document",
                                                        image: Image(uiImage: (pdf.page(at: 0)?.thumbnail(of: CGSize(width: 100, height: 100),
                                                                                                          for: .cropBox))!)))
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

extension PDFDocument: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .pdf) { pdf in
                if let data = pdf.dataRepresentation() {
                    return data
                } else {
                    return Data()
                }
            } importing: { data in
                if let pdf = PDFDocument(data: data) {
                    return pdf
                } else {
                    return PDFDocument()
                }
            }

        DataRepresentation(exportedContentType: .pdf) { pdf in
            if let data = pdf.dataRepresentation() {
                return data
            } else {
                return Data()
            }
        }
     }
}
