//
//  SpeedOverlayView.swift
//  TeslaCamViewer
//
//  Created by euwang on 4/10/26.
//

import SwiftUI


struct TelemetryOverlayView: View {
    let model: TelemetryOverlay

    var body: some View {
        HStack(spacing: 18) {
            VStack(spacing: 10) {
                TelemetryGearView(text: model.gearText)
                TelemetryPedalBarView(value: model.brakeValue, color: .red)
            }

            TelemetryBlinkerView(direction: .left, isVisible: model.leftBlinkerVisible)

            TelemetrySpeedBlockView(
                speedText: model.speedText,
                unitText: model.unitText
            )
            .frame(width: 60)
            

            TelemetryBlinkerView(direction: .right, isVisible: model.rightBlinkerVisible)

            VStack(spacing: 10) {
                TelemetrySteeringWheelView(
                    isAutoPilotActive: model.autopilotActive,
                    rotateAngle: model.steeringAngleValue
                )
                TelemetryPedalBarView(value: model.throttleValue, color: .green)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(width: 380, height: 110)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)
        )
        .shadow(radius: 10, y: 4)
        .scaleEffect(0.6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Speed \(model.speedText) \(model.unitText), Gear \(model.gearText), Trottle \(model.throttleValue), Brake \(model.brakeValue)")
    }
}

private struct TelemetryGearView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundStyle(.primary.opacity(0.85))
            .frame(width: 24)
    }
}

private enum TelemetryBlinkerDirection {
    case left
    case right
}

private struct TelemetryBlinkerView: View {
    let direction: TelemetryBlinkerDirection
    let isVisible: Bool

    private var systemImageName: String {
        switch direction {
        case .left:
            return "arrowtriangle.left.fill"
        case .right:
            return "arrowtriangle.right.fill"
        }
    }

    var body: some View {
        Image(systemName: systemImageName)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.green.opacity(isVisible ? 0.95 : 0.0))
            .frame(width: 14, height: 14)
            .animation(.easeInOut(duration: 0.2), value: isVisible)
            .accessibilityHidden(true)
    }
}

private struct TelemetrySpeedBlockView: View {
    let speedText: String
    let unitText: String

    var body: some View {
        VStack(spacing: 2) {
            Text(speedText)
                .font(.system(size: 42, weight: .regular, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(unitText)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

private struct TelemetrySteeringWheelView: View {
    let isAutoPilotActive: Bool
    let rotateAngle: Double

    var body: some View {
        Image(systemName: "steeringwheel")
            .font(.system(size: 17, weight: .medium))
            .rotationEffect(Angle(degrees: rotateAngle))
            .foregroundStyle(isAutoPilotActive ? .blue : .primary.opacity(0.7))
            .frame(width: 20, height: 20)
    }
}


struct TelemetryPedalBarView: View {
    let value: Double   // 0...1
    let color: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(.white.opacity(0.15))

            Capsule()
                .fill(color)
                .frame(maxHeight: .infinity)
                .scaleEffect(y: value, anchor: .bottom)
                .animation(.easeOut(duration: 0.15), value: value)
        }
        .frame(width: 8, height: 28)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.green.opacity(0.45), .gray.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        TelemetryOverlayView(model: .preview)
            .padding()
    }
    .frame(width: 460, height: 200)
}
