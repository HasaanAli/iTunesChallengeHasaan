//
//  AppCommonsLocalStorage.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import RealmSwift

/// Class to store/update common overall app-related state, e.g lastVisited: when user last visited the app.
class AppCommonsLocalStorage {
    let realm: Realm

    /// Throwing initializer.
    /// - Throws: Realm initialization error.
    init() throws {
        realm = try Realm()
    }

    /// Store last visited date to local storage.
    func store(lastVisited: Date) {
        realm.writeAsync({
            let appCommons = AppCommons(lastVisitedDate: lastVisited)
            let realmAppCommons = RealmAppCommons(appCommons: appCommons)
            self.realm.add(realmAppCommons, update: .modified)
        })
    }

    /// Get last visited date from local storage.
    func getLastVisited() -> Date? {
        if let realmAppCommons = realm.objects(RealmAppCommons.self).first {
            let appCommons = realmAppCommons.domainModel
            return appCommons.lastVisitedDate
        } else {
            return nil
        }
    }
}
