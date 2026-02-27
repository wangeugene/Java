//
//  ContentView.swift
//  bible
//
//  Created by euwang on 2/26/26.
//

import SwiftUI
import SQLite3
import Combine

// MARK: - Simple models
struct VerseRow: Identifiable {
    let id: Int
    let verse: Int
    let text: String
}

// MARK: - Repository (SQLite queries)
final class BibleRepository {
    private let db: OpaquePointer?

    init(db: OpaquePointer?) {
        self.db = db
    }

    /// Matches your actual schema:
    /// verses(id, book INTEGER, chapter INTEGER, verse INTEGER, text TEXT)
    func loadChapter(book: Int, chapter: Int) -> [VerseRow] {
        guard let db else { return [] }

        let sql = """
        SELECT id, verse, text
        FROM verses
        WHERE book = ? AND chapter = ?
        ORDER BY verse;
        """

        var stmt: OpaquePointer?
        var rows: [VerseRow] = []

        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            let msg = String(cString: sqlite3_errmsg(db))
            print("sqlite prepare failed: \(msg)")
            return []
        }
        defer { sqlite3_finalize(stmt) }

        sqlite3_bind_int(stmt, 1, Int32(book))
        sqlite3_bind_int(stmt, 2, Int32(chapter))

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let verseNo = Int(sqlite3_column_int(stmt, 1))

            let cText = sqlite3_column_text(stmt, 2)
            let text = cText != nil ? String(cString: cText!) : ""

            rows.append(VerseRow(id: id, verse: verseNo, text: text))
        }

        return rows
    }
}

@MainActor
final class ReaderViewModel: ObservableObject {
    @Published var verses: [VerseRow] = []

    private let repo: BibleRepository

    // Default starting point
    @Published var book: Int = 1      // Genesis
    @Published var chapter: Int = 1

    init(repo: BibleRepository) {
        self.repo = repo
    }

    func loadCurrentChapter() {
        verses = repo.loadChapter(book: book, chapter: chapter)
    }
}

struct ContentView: View {
    @StateObject private var vm: ReaderViewModel

    init() {
        // Ensure DB is installed/opened
        _ = DatabaseManager.shared
        let repo = BibleRepository(db: DatabaseManager.shared.getDB())
        _vm = StateObject(wrappedValue: ReaderViewModel(repo: repo))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Book", selection: $vm.book) {
                        ForEach(1..<67, id: \.self) { b in
                            Text(BibleCanon.name(forBook: b)).tag(b)
                        }
                    }

                    Stepper(
                        "Chapter \(vm.chapter)",
                        value: $vm.chapter,
                        in: 1...BibleCanon.maxChapter(forBook: vm.book)
                    )
                }

                Section {
                    ForEach(vm.verses) { v in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(v.verse)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 28, alignment: .trailing)

                            Text(v.text)
                                .textSelection(.enabled)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(titleFor(book: vm.book, chapter: vm.chapter))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                vm.loadCurrentChapter()
            }
            .onChange(of: vm.book) { _, _ in
                vm.chapter = min(vm.chapter, BibleCanon.maxChapter(forBook: vm.book))
                vm.loadCurrentChapter()
            }
            .onChange(of: vm.chapter) { _, _ in
                vm.loadCurrentChapter()
            }
        }
    }

    private func titleFor(book: Int, chapter: Int) -> String {
        "\(BibleCanon.name(forBook: book)) \(chapter)"
    }
}

#Preview {
    ContentView()
}
