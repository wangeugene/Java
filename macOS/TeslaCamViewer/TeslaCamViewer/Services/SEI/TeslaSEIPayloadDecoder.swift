import Foundation

struct TeslaSEIPayloadDecoder {

    func decodeSEI(from payload: Data) -> [SEIMessage] {
        var messages: [SEIMessage] = []
        var offset = 0

        while offset < payload.count {
            if payload.count - offset < 2 {
                    print("ℹ️ SEI parsing reached trailing bytes, stopping")
                    break
            }


            var payloadType = 0
            while offset < payload.count {
                let byte = Int(payload[offset])
                offset += 1
                payloadType += byte
                if byte != 0xFF { break }
            }

            
              if offset >= payload.count {
                  print("ℹ️ End of SEI payload reached")
                  break
              }
            
            var payloadSize = 0
            while offset < payload.count {
                let byte = Int(payload[offset])
                offset += 1
                payloadSize += byte
                if byte != 0xFF { break }
            }

            guard payloadSize >= 0, offset + payloadSize <= payload.count else {
                print("""
                ⚠️ SEI payload overflow
                payload.count: \(payload.count)
                offset: \(offset)
                payloadType: \(payloadType)
                payloadSize: \(payloadSize)
                remaining: \(payload.count - offset)
                """)
                break
            }

            let rawMessageData = payload.subdata(in: offset ..< offset + payloadSize)
            offset += payloadSize

            let uuid: UUID?
            let payloadData: Data

            // H.264/H.265 SEI payloadType 5 = user_data_unregistered
            // Tesla telemetry is very likely carried here.
            if payloadType == 5, rawMessageData.count >= 16 {
                let uuidBytes = rawMessageData.prefix(16)
                uuid = uuidFromBytes(Data(uuidBytes))
                payloadData = Data(rawMessageData.dropFirst(16))
            } else {
                uuid = nil
                payloadData = rawMessageData
            }

            messages.append(
                SEIMessage(
                    payloadType: payloadType,
                    payloadSize: payloadSize,
                    uuid: uuid,
                    payloadData: payloadData
                )
            )
        }

        return messages
    }
}

private extension TeslaSEIPayloadDecoder {
    func uuidFromBytes(_ data: Data) -> UUID? {
        guard data.count == 16 else { return nil }

        let bytes = Array(data)
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5],
            bytes[6], bytes[7],
            bytes[8], bytes[9],
            bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }
}
