import SwiftUI

struct HeroesView: View {
    @State private(set) var viewModel: HeroesViewModel

    var body: some View {
        NavigationSplitView {
            sideBar
        } detail: {
            if let heroDetails = viewModel.heroDetails {
                detailsView(heroDetails: heroDetails)
            }
        }
        .disabled(viewModel.isHeroSectionsLoading)
        .toolbar {
            ToolbarItem(placement: .status) {
                RefreshButton(isRunning: $viewModel.isHeroSectionsLoading, action: viewModel.refresh)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button(systemImage: .folder, action: viewModel.pathPickerSelected)
                Button(systemImage: .lockShield, action: viewModel.permissionSelected)
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .presentAlert(title: $viewModel.alertString)
    }

    private var sideBar: some View {
        VStack(spacing: 0) {
            List(viewModel.heroSections, selection: $viewModel.heroDetailsSelection) { section in
                Section(isExpanded: $viewModel.isExpandedHeroSections[section.index]) {
                    ForEach(section.data.details) { heroDetails in
                        Text(.heroesLevel(level: heroDetails.level))
                            .tag(heroDetails)
                    }
                } header: {
                    Row(title: section.data.title) {
                        viewModel.toggleHeroSections(sectionIndex: section.index)
                    }
                }
            }
            .listStyle(.sidebar)
            SearchTextField(placeholder: .heroesFilterSections, text: $viewModel.heroSectionsSearchText)
                .padding(.viewPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .redacted(reason: viewModel.isHeroSectionsLoading ? .placeholder : [])
    }

    private func detailsView(heroDetails: HeroDetails) -> some View {
        VStack(spacing: 0) {
            SearchTextField(placeholder: .heroesFilterDetails, text: $viewModel.heroDetailsSearchText)
                .padding(.viewPadding)
            ScrollView {
                if let heroDetailsContent = viewModel.heroDetailsContent {
                    HStack {
                        Text(heroDetailsContent)
                            .padding()
                            .background(heroDetails.content == viewModel.heroDetailsSearchText ? .red : .clear)
                            .textSelection(.enabled)
                            .redacted(reason: viewModel.isHeroContentsLoading ? .placeholder : [])
                        Spacer()
                    }
                }
            }
            Button {
                viewModel.loadCode(heroDetails: heroDetails)
            } label: {
                Text(.heroesLoadCode)
                    .padding(.viewPadding)
            }
            .cornerRadius(.cornerRadius)
        }
        .padding(.bottom, BottomPaddings.details)
    }
}

private enum BottomPaddings {
    static let details: CGFloat = 12
}
