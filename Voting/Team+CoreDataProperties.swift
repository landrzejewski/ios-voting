//
//  Team+CoreDataProperties.swift
//  Voting
//
//  Created by Łukasz Andrzejewski on 09/07/2020.
//  Copyright © 2020 Inbright Łukasz Andrzejewski. All rights reserved.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var wins: Int32
    @NSManaged public var isFavourite: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var url: URL?
    @NSManaged public var lastWin: Date?
    @NSManaged public var selector: String?
    @NSManaged public var photo: Data?
    @NSManaged public var color: NSObject?

}
