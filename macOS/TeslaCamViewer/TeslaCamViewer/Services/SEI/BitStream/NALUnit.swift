//
//  TeslaNALUnitType.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//


import Foundation

enum NALUnitType: Equatable {
    case sei
    case other(Int)
}

struct NALUnit {
    let type: NALUnitType
    let payload: Data
}
