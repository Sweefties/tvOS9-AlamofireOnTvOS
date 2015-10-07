//
//  MainTableViewController.swift
//  tvOS9-AlamofireOnTvOS
//
//  Created by Wlad Dicario on 06/10/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//


import UIKit

class MainTableViewController: UITableViewController {

    
    // MARK: - Properties
    static let storyboardIdentifier = "SearchResultsViewController"
    
    let cellID = "defaultCell"
    
    var dataArray = [AppModel]()
    
    var SearchString = "" {
        didSet {
            // Return if the SearchString hasn't changed.
            guard SearchString != oldValue else { return }
            
            if SearchString.isEmpty {
                // we make nothing
                print("No Keyword")
            }
            else {
                getDataFromSearch(SearchString)
            }
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AppTableViewCell
        // Configure the cell...
        guard let app : AppModel = dataArray[indexPath.row] as AppModel else { print("no value") }
        
        let viewModel = AppViewModel()
        cell.configure(withDataSource: app, delegate: viewModel)
        
        return cell
    }
    
}


//MARK: - AlamofireSearchAPI -> MainTableViewController Extension
typealias AlamofireSearchAPI = MainTableViewController
extension AlamofireSearchAPI {
    
    /// get data from search
    func getDataFromSearch(keyword:String) {
        // make an instance
        let manager = Manager.sharedInstance
        
        // create a request
        manager.request(.GET, "https://itunes.apple.com/search", parameters: ["term":keyword,"country":"us","entity":"software"])
            // Add a handler
            .responseJSON(options: NSJSONReadingOptions.AllowFragments) { response in
                
                if let JSON = response.result.value {
                    
                    guard let contents:NSArray = JSON.objectForKey("results") as? NSArray else { return self.showAlertController() }
                    
                    if contents.count > 0 {
                        // remove all elements
                        self.dataArray.removeAll(keepCapacity: true)
                        // prepare values
                        for key in contents {
                            if let dict = key as? NSDictionary {
                                
                                let name = dict.valueForKey("trackName") as! String
                                let desc = dict.valueForKey("description") as! String
                                let thum = dict.valueForKey("artworkUrl60") as! String
                                let urls = dict.valueForKey("trackViewUrl") as! String
                                let sell = dict.valueForKey("sellerName") as! String
                                // append data array with `Appmodel`
                                self.dataArray.append(AppModel(trackName: name, descriptionText: desc, thumbnailUrl: thum, Url: urls, sellerName: sell))
                            }
                        }
                        // reload data
                        self.tableView.reloadData()
                    }else{
                        // alert controller..
                        self.showAlertController()
                    }
                }
        }
    }
    
    /// show simple alert controller
    func showAlertController() {
        let title = NSLocalizedString("No Results founded", comment: "")
        let message = NSLocalizedString("No Apps!", comment: "")
        let acceptButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let acceptAction = UIAlertAction(title: acceptButtonTitle, style: .Default) { _ in
            print("The simple alert's accept action occurred.")
        }
        
        // Add the action.
        alertController.addAction(acceptAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}


//MARK: - MainSearchController -> MainTableViewController Extension
typealias MainSearchController = MainTableViewController
extension MainSearchController : UISearchControllerDelegate, UISearchResultsUpdating {
    
    /// UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        SearchString = searchController.searchBar.text ?? ""
    }
}


//MARK: - UIImageView Extension
extension UIImageView {
    /**
     GCD Download Image From Url with Asynchronous.
     - parameter link:              `String` url for data task.
     - parameter contentMode:       `UIViewContentMode` adjusts content mode.
     - returns: The current ImageView from url and sizing ContentMode.
     */
    func downloadImageFrom(url link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}