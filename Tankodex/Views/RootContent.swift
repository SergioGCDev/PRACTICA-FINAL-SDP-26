struct RootContent: View {
    let showLoadingOverlay: Bool

    @Environment(generalVM.self) private var generalViewModel
    @Environment(libraryVM.self) private var libraryViewModel
    @Environment(searchVM.self) private var searchViewModel

    var body: some View {
        ZStack {
            ContentView()
                .opacity(showLoadingOverlay ? 0 : 1)

            if showLoadingOverlay {
                LoadingView()
                    .transition(.opacity)
            }
        }
    }
}