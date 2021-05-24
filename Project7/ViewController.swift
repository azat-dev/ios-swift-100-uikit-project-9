//
//  ViewController.swift
//  Project7
//
//  Created by Azat Kaiumov on 24.05.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    
    func loadData() {
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        guard let petitions = Petitions(json: data) else {
            return
        }
        
        self.petitions = petitions.results
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petition = petitions[indexPath.row]
        
        let detailViewController = DetailViewController()
        detailViewController.detailItem = petition
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

