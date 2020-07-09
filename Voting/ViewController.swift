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
    @IBOutlet weak var favouriteLabel: UILabel!
    @IBOutlet weak var teamSegmentedControl: UISegmentedControl!
    
    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        guard let team = loadTeam(selector: teamSegmentedControl.titleForSegment(at: 0)!) else {
            return
        }
        updateView(team: team)
    
        
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
        guard let managedContext = getManagedContext(), try! managedContext.count(for: Team.fetchRequest()) == 0,
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
    
    func loadTeam(selector: String) -> Team? {
        if let managedContext = getManagedContext() {
            let request: NSFetchRequest<Team> = Team.fetchRequest()
            request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Team.selector), selector])
            do {
                let results = try managedContext.fetch(request)
                return results.first
            } catch let error as NSError {
                print("Could not load team \(error)")
            }
        }
        return nil
    }
    
    func updateView(team: Team) {
        guard let photoData = team.photo else {
            return
        }
        imageView.image = UIImage(data: photoData)
        titleLabel.text = team.name
        ratingLabel.text = "Rating: \(team.rating)/5.0"
        winsLabel.text = "Wins: \(team.wins)"
        lastWinLabel.text = "Last win: \(dateFormatter.string(from: team.lastWin!))"
        favouriteLabel.text = "Is favourite: \(team.isFavourite)";
    }
    
}

