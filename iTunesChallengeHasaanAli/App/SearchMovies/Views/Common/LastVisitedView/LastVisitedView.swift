//
//  LastVisitedView.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import SwiftUI

/// The view to show the date when user last opened the current app.
struct LastVisitedView: View {
    @StateObject private var vm = LastVisitedViewModel()
    
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text("Last visited: " + vm.lastVisited)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    vm.onActive()
                case .inactive:
                    break
                case .background:
                    vm.onBackground()
                @unknown default:
                    break
                }
            }
    }
}

#Preview {
    LastVisitedView()
}

