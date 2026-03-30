//
//  FolderPicker.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//

import AppKit

enum FolderPicker {
    static func pickTeslaCamFolder() -> URL? {
           let panel = NSOpenPanel()
           panel.canChooseFiles = false
           panel.canChooseDirectories = true
           panel.allowsMultipleSelection = false
           panel.prompt = "Choose TeslaCam Folder"

           return panel.runModal() == .OK ? panel.url : nil
       }
}
