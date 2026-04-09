//
//  TeslaTelemetryDecoder.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//


//
//  TeslaTelemetryDecoder.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/8/26.
//

import Foundation

struct TeslaTelemetryDecoder {

    func decode(from message: SEIMessage, sourceClipURL: URL) -> TeslaSEISample? {
        // NAL UNIT = [ NAL HEADER ] [ NAL UNIT ]
        // NAL HEADER = [ F ] [ NRL ] [ TYPE ] , F = Fixed Bit; NRL =
        // Only handle SEI user_data_unregistered messages (payloadType == 5)
        //     •    NAL type for SEI is 6
        // •    SEI message payloadType == 5 is user_data_unregistered
        guard message.payloadType == 5 else { return nil }

        
        
        // SEIMessage.payloadData
        // [UUID (16 bytes)] + [Tesla telemetry binary data] = payloadData
        let data = message.payloadData
        print("message.payloadType:", message.payloadType)
        print("message.payloadSize:", message.payloadSize)
        print("message.uuid:", message.uuid?.uuidString ?? "nil")

        let hex = data.prefix(32).map { String(format: "%02X", $0) }.joined(separator: " ")
        print("payloadData first 32 bytes:", hex)
        
        guard data.count >= 16 else { return nil }

        // payload = [UUID][Tesla Telemetry Data]
        let payload = data.dropFirst(16)   // 🔥 remove UUID

        // Temporary heuristic decoding (will refine later)
        let speed = readFloat(payload, offset: 0)
        let accelX = readFloat(payload, offset: 4)
        let accelY = readFloat(payload, offset: 8)
        let accelZ = readFloat(payload, offset: 12)

        return TeslaSEISample(
            version: nil,
            gearState: nil,
            frameSequenceNumber: nil,
            vehicleSpeedMps: speed.map { Double($0) },
            acceleratorPedalPosition: nil,
            steeringWheelAngle: nil,
            blinkerOnLeft: nil,
            blinkerOnRight: nil,
            brakeApplied: nil,
            autopilotState: nil,
            latitudeDeg: nil,
            longitudeDeg: nil,
            headingDeg: nil,
            linearAccelerationMps2X: accelX.map { Double($0) },
            linearAccelerationMps2Y: accelY.map { Double($0) },
            linearAccelerationMps2Z: accelZ.map { Double($0) },
            sourceClipURL: sourceClipURL
        )
    }
}

private extension TeslaTelemetryDecoder {

    func readFloat(_ data: Data, offset: Int) -> Float? {
        guard offset + 4 <= data.count else { return nil }

        let value: UInt32 = data.withUnsafeBytes { rawBuffer in
            rawBuffer.loadUnaligned(fromByteOffset: offset, as: UInt32.self)
        }

        return Float(bitPattern: UInt32(littleEndian: value))
    }
}
