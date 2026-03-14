//
//  ContentView.swift
//  TxtReader
//
//  Created by euwang on 3/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = "加载中…"
    @State private var fontSize: CGFloat = 18
    @State private var lineSpacing: CGFloat = 6
    @State private var isDark: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                (isDark ? Color.black : Color(white: 0.98)).ignoresSafeArea()
                ScrollView {
                    Text(text)
                        .font(.system(size: fontSize))
                        .lineSpacing(lineSpacing)
                        .foregroundStyle(isDark ? .white : .black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("小说阅读")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        isDark.toggle()
                    } label: {
                        Image(systemName: isDark ? "sun.max" : "moon")
                    }

                    Spacer()

                    Stepper("字号 \(Int(fontSize))", value: $fontSize, in: 12...28, step: 1)
                        .labelsHidden()
                }
            }
        }
        .task {
            // Load bundled text file named "novel.txt". Add it to the target in Xcode.
            text = loadBundledText(named: "novel", ext: "txt")
        }
    }

    private func loadBundledText(named name: String, ext: String) -> String {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            return "未找到资源：\(name).\(ext)\n请将文件添加到工程并勾选目标。"
        }
        do {
            let data = try Data(contentsOf: url)
            if let str = String(data: data, encoding: .utf8)
                ?? String(data: data, encoding: .utf16LittleEndian)
                ?? String(data: data, encoding: .utf16BigEndian)
                ?? String(data: data, encoding: .unicode) {
                return normalizeLineEndings(str)
            } else {
                // Fallback decode
                return normalizeLineEndings(String(decoding: data, as: UTF8.self))
            }
        } catch {
            return "读取失败：\(error.localizedDescription)"
        }
    }

    private func normalizeLineEndings(_ s: String) -> String {
        s.replacingOccurrences(of: "\r\n", with: "\n")
         .replacingOccurrences(of: "\r", with: "\n")
    }
}

#Preview {
    ContentView()
}
