//
//  LastVisitedViewModel.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import Foundation
import Combine

class LastVisitedViewModel: ObservableObject {
    // When user first time opens the app, the value is a string "Now".
    @Published var lastVisited: String = "Now"
    private let dateFormatter: DateFormatter

    // Dependencies
    private let appCommonsLocalStorage = DependencyContainer.shared.appCommonsLocalStorage

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    func onBackground() {
        appCommonsLocalStorage?.store(lastVisited: Date.now)
    }

    func onActive() {
        if let lastVisited = appCommonsLocalStorage?.getLastVisited() {
            self.lastVisited = dateFormatter.string(from: lastVisited)
        }
    }
}
