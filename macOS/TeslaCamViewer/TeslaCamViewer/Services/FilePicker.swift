//
//  FilePicker.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/22/26.
//


import AppKit
import UniformTypeIdentifiers

class FilePicker {
    
    static func pickVideo() -> URL? {
        let panel = NSOpenPanel()
        
        panel.title = "Select a video file"
        panel.allowedContentTypes = [UTType.mpeg4Movie] // .mp4
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        let response = panel.runModal()
        
        if response == .OK {
            return panel.url
        }
        
        return nil
    }
}

