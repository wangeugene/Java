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

struct ContentView: View {
    @State private var ipAddress: String = "Loading..."
    @State private var publicIP: String = "Loading..."
    @State private var country: String = "Loading..."
    @State private var city: String = "Loading..."
    
    var body: some View {
        VStack {
            // ... your other UI code ...
            Text("LAN IP: \(ipAddress)")
            Text("Public IP: \(publicIP)")
            Text("Country: \(country)")
            Text("City: \(city)")
            Button("Refresh") {
                refreshInfo()
            }
        }
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
