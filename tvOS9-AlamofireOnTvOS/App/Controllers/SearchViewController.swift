//
//  SearchViewController.swift
//  tvOS9-AlamofireOnTvOS
//
//  Created by Wlad Dicario on 06/10/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    // MARK: - Interface
    @IBOutlet weak var searchButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.setTitle("Search App!", for: UIControlState())
    }

    
    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//MARK: - SearchActions -> SearchViewController Extension
typealias SearchActions = SearchViewController
extension SearchViewController : UISearchControllerDelegate {
    
    /// Show Search Controller
    @IBAction func showSearchController(_ sender: AnyObject) {
        /*
        Instantiate an instance of a `SearchResultsViewController` from the
        storyboard. This will be used by the `UISearchController` to display
        search results.
        */
        guard let resultsController = storyboard?.instantiateViewController(withIdentifier: MainTableViewController.storyboardIdentifier) as? MainTableViewController else { fatalError("Unable to instantiate a SearchResultsViewController.") }
        
        // Create and configure a `UISearchController`.
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        let searchPlaceholderText = NSLocalizedString("Enter keyword (e.g. Apple)", comment: "")
        searchController.searchBar.placeholder = searchPlaceholderText
        
        searchController.searchBar.keyboardType = UIKeyboardType.default
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.delegate = self
        // Present the search controller from the self view.
        self.present(searchController, animated: true, completion: nil)
    }
}
