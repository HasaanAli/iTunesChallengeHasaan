//
//  RealmAppCommons.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import RealmSwift

/// Persistence Model for `AppCommons`.
class RealmAppCommons: Object {
    // MARK: - Persistance model properties to map domain model

    @Persisted(primaryKey: true) var id: String
    @Persisted var lastVisitedDate: Date?

    // MARK: - Domain model to persistance model conversion

    convenience init(appCommons: AppCommons) {
        self.init()
        self.id = appCommons.id
        self.lastVisitedDate = appCommons.lastVisitedDate
    }

    var domainModel: AppCommons {
        return AppCommons(lastVisitedDate: self.lastVisitedDate)
    }
}
