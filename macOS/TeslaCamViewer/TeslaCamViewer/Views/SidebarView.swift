//
//  SidebarView.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: TeslaCamBrowserViewModel
    @State private var selectedGroup: TeslaClipGroup?

    var body: some View {
        List(selection: $selectedGroup) {
            if let rootURL = viewModel.rootURL {
                Section("TeslaCam") {
                    Text(rootURL.lastPathComponent)
                        .font(.headline)
                }
            }

            Section("Folders") {
                ForEach(viewModel.groups) { group in
                    Label(group.displayName, systemImage: "folder")
                        .tag(group)
                }
            }
        }
        .navigationTitle("TeslaCam")
        .onAppear {
            selectedGroup = viewModel.selectedGroup
        }
        .onChange(of: selectedGroup) { _, newValue in
            DispatchQueue.main.async {
                viewModel.selectGroup(newValue)
            }
        }
        .onChange(of: viewModel.selectedGroup) { _, newValue in
            if selectedGroup != newValue {
                selectedGroup = newValue
            }
        }
    }
}
