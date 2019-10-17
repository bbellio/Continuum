//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
// MARK: - Properties and Global Variables
    var resultsArray: [Post] = []
    var isSearching: Bool = false
    var dataSource: [Post] {
        return isSearching ? resultsArray : PostController.sharedInstance.posts
//        if isSearching == true {
//            return resultsArray
//        } else {
//            return PostController.sharedInstance.posts
//        }
    }
    
// MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        performPostSync { (success) in
            if success {
                print("Succesfully synced posts")
            } else {
                print("Error fetching posts")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultsArray = PostController.sharedInstance.posts
        tableView.reloadData()
    }

// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        let post = dataSource[indexPath.row]
        cell.post = post
        return cell
    }

// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let destination = segue.destination as? PostDetailTableViewController else { return }
            let post = PostController.sharedInstance.posts[indexPath.row]
            destination.post = post
        } 
    }
    
// MARK: - Custom Functions
    func performPostSync(completion: @escaping (_ success: Bool) -> Void) {
        PostController.sharedInstance.fetchPosts { (posts) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("Successfully performed fetch posts method")
                completion(true)
            }
        }
    }
    
} // End of class

// MARK: - Class Extensions
extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.sharedInstance.posts.filter { $0.matches(searchTerm: searchText.lowercased()) }
        // Because inside UISearchBarDelegate, not on background thread - no need to call on main thread
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.sharedInstance.posts
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        return isSearching
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
} // End of extension
