//
//  SEIMessage.swift
//  TeslaCamViewer
//
//•    payloadType: SEI message type, e.g. 5 for user_data_unregistered
//•    payloadSize: declared size from the SEI message header
//•    uuid: only relevant for Tesla-style user_data_unregistered payloads
//•    payloadData: the actual payload bytes after any UUID stripping
//
//  Created by euwang on 4/8/26.
//


import Foundation

struct SEIMessage {
    let payloadType: Int
    let payloadSize: Int
    let uuid: UUID?
    let payloadData: Data
}
