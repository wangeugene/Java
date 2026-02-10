//
//  ContentView.swift
//  introduction
//
//  Created by euwang on 11/28/25.
//

import SwiftUI
import Foundation
import SystemConfiguration.CaptiveNetwork
import Network

struct IPGeolocation: Decodable {
    let country: String?
    let city: String?
}

func getWiFiAddress() -> String? {
    var address: String?
    var ifaddrs: UnsafeMutablePointer<ifaddrs>?
    if getifaddrs(&ifaddrs) == 0 {
        var ptr = ifaddrs
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            guard let interface = ptr?.pointee else { continue }
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                if let name = String(validatingUTF8: interface.ifa_name), name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddrs)
    }
    return address
}

func fetchPublicIP() async -> String {
    let url = URL(string: "https://ifconfig.me/ip")!
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let ip = String(data: data, encoding: .utf8) {
            return ip
        }
    } catch {
        // Ignore errors for now
    }
    return "Unavailable"
}

func fetchGeolocation(for ip: String) async -> IPGeolocation? {
    let url = URL(string: "https://ipinfo.io")!
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let geo = try? JSONDecoder().decode(IPGeolocation.self, from: data)
        return geo
    } catch {
        return nil
    }
}

#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

func copyToPasteboard(_ text: String) {
    #if canImport(UIKit)
    UIPasteboard.general.string = text
    #elseif canImport(AppKit)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
    #endif
}

struct InfoRow: View {
    let title: String
    let value: String

    @State private var copied = false

    private var isCopyable: Bool {
        !value.isEmpty && value != "Unavailable"
    }

    var body: some View {
        HStack {
            Text("\(title): \(value)")
            Spacer()
            Button {
                copyToPasteboard(value)
                withAnimation { copied = true }
                // Revert the icon after a short delay
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // ~1s
                    withAnimation { copied = false }
                }
            } label: {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Copy \(title)")
            .disabled(!isCopyable)
            .opacity(isCopyable ? 1 : 0.4)
        }
    }
}


struct ContentView: View {
    @State private var ipAddress: String = "Loading..."
    @State private var publicIP: String = "Loading..."
    @State private var country: String = "Loading..."
    @State private var city: String = "Loading..."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            InfoRow(title: "LAN IP", value: ipAddress)
            InfoRow(title: "Public IP", value: publicIP)
            InfoRow(title: "Country", value: country)
            InfoRow(title: "City", value: city)
            Button("Refresh") {
                refreshInfo()
            }
        }
        .padding()
        .onAppear {
            refreshInfo()
        }
    }
    
    private func refreshInfo() {
        if let ip = getWiFiAddress() {
            ipAddress = ip
        } else {
            ipAddress = "Unavailable"
        }
        Task {
            publicIP = await fetchPublicIP()
            if let geo = await fetchGeolocation(for: publicIP) {
                country = geo.country ?? "Unavailable"
                city = geo.city ?? "Unavailable"
            } else {
                country = "Unavailable"
                city = "Unavailable"
            }
        }
    }
}

#Preview {
    ContentView()
}
