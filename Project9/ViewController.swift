//
//  ViewController.swift
//  Project7
//
//  Created by Azat Kaiumov on 24.05.2021.
//

import UIKit

class ViewController: UITableViewController {
    var filteredPetitions = [Petition]()
    var petitions = [Petition]() {
        didSet {
            updateFilteredItems()
        }
    }
    
    var filterText: String? {
        didSet {
            updateFilteredItems()
        }
    }
    
    @objc func showError() {
        let alert = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
    
    @objc func reloadTable() {
        self.tableView.performSelector(
            onMainThread: #selector(UITableView.reloadData),
            with: nil,
            waitUntilDone: false
        )
    }
    
    func loadData(tabIndex: Int) {
        let urlString: String
        
        let showErrorInMainThread = {
            self.performSelector(
                onMainThread: #selector(self.showError),
                with: nil,
                waitUntilDone: false
            )
        }
        
        if tabIndex == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        guard let url = URL(string: urlString) else {
            showErrorInMainThread()
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            showErrorInMainThread()
            return
        }
        
        guard let petitions = Petitions(json: data) else {
            showErrorInMainThread()
            return
        }
        
        self.petitions = petitions.results
        performSelector(
            onMainThread: #selector(reloadTable),
            with: nil,
            waitUntilDone: false
        )
    }
    
    @objc func creditsButtonTapped() {
        let alert = UIAlertController(
            title: "Credits",
            message: "The data comes from the \"We The People API\" of the Whitehouse",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
    
    func updateFilteredItems() {
        guard let filterText = filterText  else {
            filteredPetitions = petitions
            return
        }
        
        let lowercasedFilterText = filterText.lowercased()
        
        filteredPetitions = petitions.filter { $0.title.lowercased().contains(lowercasedFilterText) || $0.body.lowercased().contains(lowercasedFilterText) }
    }
    
    func updateFilter(text: String?) {
        self.filterText = text
        updateFilterButton()
        tableView.reloadData()
    }
    
    @objc func filterButtonTapped() {
        let alert = UIAlertController(
            title: "Filter",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField()
        alert.textFields?[0].text = filterText
        
        let submitButton = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alert] _ in
            guard let text = alert?.textFields?[0].text else {
                return
            }
            
            let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let filterText = cleanedText.count > 0 ? cleanedText : nil
            self?.updateFilter(text: filterText)
        }
        
        let clearButton = UIAlertAction(title: "Clear", style: .destructive) {
            [weak self] _ in
            self?.updateFilter(text: nil)
        }
        
        alert.addAction(submitButton)
        alert.addAction(clearButton)
        
        present(alert, animated: true)
    }
    
    func updateFilterButton() {
        let iconName = filterText != nil ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle"
        
        navigationItem.leftBarButtonItem = .init(
            image: .init(systemName: iconName),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
    }
    
    func initNavBar() {
        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "info.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(creditsButtonTapped)
        )
        
        updateFilterButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        
        let tabIndex = navigationController?.tabBarItem.tag ?? 0
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadData(tabIndex: tabIndex)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petition = filteredPetitions[indexPath.row]
        
        let detailViewController = DetailViewController()
        detailViewController.detailItem = petition
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

