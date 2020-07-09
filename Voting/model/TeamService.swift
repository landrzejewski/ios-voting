//
//  TeamService.swift
//  Voting
//
//  Created by Łukasz Andrzejewski on 09/07/2020.
//  Copyright © 2020 Inbright Łukasz Andrzejewski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TeamService {
    
    private var asyncFetchRequest: NSAsynchronousFetchRequest<Team>?
    
    var currentTeam: Team?
    
    func loadTeam(selector: String, callback:  @escaping (Team) -> ()) {
        let managedContext = AppDelegate.shared.context
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Team.selector), selector])
        asyncFetchRequest = NSAsynchronousFetchRequest<Team>(fetchRequest: request) { result in
            guard let team = result.finalResult?.first else {
                return
            }
            callback(team)
        }
        do {
            try managedContext.execute(asyncFetchRequest!)
        } catch let error as NSError {
            print("Could not load team \(error)")
        }
        
        //do {
           // let results = try managedContext.fetch(request)
           // return results.first
        //} catch let error as NSError {
        //    print("Could not load team \(error)")
        //}
        //return nil
    }
    
    func initData() {
        let managedContext = AppDelegate.shared.context
        guard try! managedContext.count(for: Team.fetchRequest()) == 0,
            let path = Bundle.main.path(forResource: "teams-data", ofType: "plist"), let teamsData = NSArray(contentsOfFile: path) else {
                return
        }
        for teamDictionary in teamsData {
            let team = NSEntityDescription.insertNewObject(forEntityName: "Team", into: managedContext) as! Team
            let dictionary = teamDictionary as! [String: Any]
            team.id = UUID(uuidString: dictionary["id"] as! String)
            team.name = (dictionary["name"] as! String)
            team.selector = (dictionary["selector"] as! String)
            team.rating = dictionary["rating"] as! Double
            let photoName = dictionary["photo"] as! String
            team.photo = UIImage(named: photoName)?.jpegData(compressionQuality: 1)
            team.wins = dictionary["wins"] as! Int32
            team.lastWin = (dictionary["lastWin"] as! Date)
            team.isFavourite = dictionary["isFavourite"] as! Bool
            team.url = URL(string: dictionary["url"] as! String)
            let colorDictionary =  dictionary["color"] as! [String: CGFloat]
            team.color =  UIColor(red: colorDictionary["red"]! / 255, green: colorDictionary["green"]! / 255, blue: colorDictionary["blue"]! / 255,alpha: 1)
        }
        try! managedContext.save()
    }
    
    func addWinToCurrentTeam() {
        currentTeam?.wins += 1
        currentTeam?.lastWin = Date()
        AppDelegate.shared.saveContext()
    }
    
    func sync() {
        AppDelegate.shared.saveContext()
    }
    
}
