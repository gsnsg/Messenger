//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Nikhi on 17/09/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String : String]]()
    private var results = [[String : String]]()
    private var hasFetched = false
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Users"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.center = view.center
        noResultsLabel.frame = CGRect(x: view.width / 4, y : (view.height - 200) / 2,width: view.width / 2, height: 200)
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    

}


extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        results.removeAll()
        spinner.show(in: view)
        self.searchUsers(query: text)
        
    }
    
    func searchUsers(query: String) {
        // Check if array has firebase results
        // if it does: filter
        // if not fetch from firebase
        // Update UI
        if hasFetched {
            filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] (result) in
                switch result {
                case .success(let users):
                    self?.hasFetched = true
                    self?.users = users
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to fetch users: \(error)")
                }
            }
        }
        
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        let results: [[String : String]] = users.filter({ (user) -> Bool in
            guard let name = user["name"]?.lowercased()  else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            spinner.dismiss()
            self.tableView.reloadData()
        }
    }
}
