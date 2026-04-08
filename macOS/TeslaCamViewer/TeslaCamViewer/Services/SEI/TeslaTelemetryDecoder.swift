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
        // Only handle Tesla-style user_data_unregistered
        guard message.payloadType == 5 else { return nil }

        let data = message.payloadData
        guard data.count >= 16 else { return nil }

        // Temporary heuristic decoding (will refine later)
        let speed = readFloat(data, offset: 0)
        let accelX = readFloat(data, offset: 4)
        let accelY = readFloat(data, offset: 8)
        let accelZ = readFloat(data, offset: 12)

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

        return data.subdata(in: offset..<(offset + 4))
            .withUnsafeBytes { $0.load(as: Float.self) }
    }
}
