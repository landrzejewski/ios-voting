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
    
    let teamService = TeamService()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamService.initData()
        guard let team = teamService.loadTeam(selector: teamSegmentedControl.titleForSegment(at: 0)!) else {
            return
        }
        teamService.currentTeam = team
        updateView(team: team)
    }
    
    @IBAction func onAddWin(_ sender: Any) {
        teamService.addWinToCurrentTeam()
        updateView(team: teamService.currentTeam!)
    }
    
    @IBAction func onAddRating(_ sender: Any) {
        let alert = UIAlertController(title: "Rating", message: "Enter new rating:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Update", style: .destructive) { [unowned self] action in
            if let text = alert.textFields?.first?.text, let currentTeam = self.teamService.currentTeam {
                currentTeam.rating = Double(text) ?? 0.0
                self.teamService.sync()
                self.updateView(team: currentTeam)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    @IBAction func onTeamChange(_ sender: UISegmentedControl) {
        guard let team = teamService.loadTeam(selector: sender.titleForSegment(at: sender.selectedSegmentIndex)!) else {
            return
        }
        teamService.currentTeam = team
        updateView(team: team)
    }
    
    func updateView(team: Team) {
        guard let photoData = team.photo else {
            return
        }
        imageView.image = UIImage(data: photoData)
        titleLabel.text = team.name
        ratingLabel.text = "Rating: \(team.rating)"
        winsLabel.text = "Wins: \(team.wins)"
        lastWinLabel.text = "Last win: \(dateFormatter.string(from: team.lastWin!))"
        favouriteLabel.text = "Is favourite: \(team.isFavourite)"
    }
    
}
