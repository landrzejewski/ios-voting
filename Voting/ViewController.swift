//
//  ViewController.swift
//  Voting
//
//  Created by Łukasz Andrzejewski on 09/07/2020.
//  Copyright © 2020 Inbright Łukasz Andrzejewski. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lastWinLabel: UILabel!
    @IBOutlet weak var favouriteLLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        guard let managedContext = getManagedContext() else {
            return
        }
        let team = NSEntityDescription.insertNewObject(forEntityName: "Team", into: managedContext) as! Team
        team.name = "Developers"
        team.isFavourite = true
        team.rating = 5.0
        
        saveContext()
        
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        if let teams = try? getManagedContext()?.fetch(request), let firstTeam = teams.first {
            print(firstTeam.name ?? "No data")
        }
        */
    }

    @IBAction func onAddWin(_ sender: Any) {
    }
    
    @IBAction func onAddRating(_ sender: Any) {
    }
    
    @IBAction func onTeamChange(_ sender: UISegmentedControl) {
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func initData() {
        guard let managedContext = getManagedContext(), try! managedContext.count(for: Team.fetchRequest()) > 0, let path = Bundle.main.path(forResource: "teams-data", ofType: "plist"), let teamsData = NSArray(contentsOfFile: path) else {
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
            team.photo = UIImage(named: photoName)?.pngData()
            team.wins = dictionary["wins"] as! Int32
            team.lastWin = (dictionary["lastWin"] as! Date)
            team.isFavourite = dictionary["isFavourite"] as! Bool
            team.url = URL(string: dictionary["url"] as! String)
            let colorDictionary =  dictionary["color"] as! [String: CGFloat]
            team.color =  UIColor(red: colorDictionary["red"]! / 255,
                                  green: colorDictionary["green"]! / 255,
                                  blue: colorDictionary["blue"]! / 255,
                                  alpha: 1)
        }
        try! managedContext.save()
    }
    
}

