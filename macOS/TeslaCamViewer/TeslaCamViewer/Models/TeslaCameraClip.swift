//
//  TeslaCameraClip.swift
//  TeslaCamViewer
//
//  Created by euwang on 3/30/26.
//


import Foundation

struct TeslaCameraClip: Identifiable, Hashable {
    let id: URL
    let url: URL
    let timestamp: Date?
    let camera: TeslaCamera
}