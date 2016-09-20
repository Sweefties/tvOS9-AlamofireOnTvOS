//
//  MainTableViewController.swift
//  tvOS9-AlamofireOnTvOS
//
//  Created by Wlad Dicario on 06/10/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//


import UIKit
import Alamofire

class MainTableViewController: UITableViewController {

    
    // MARK: - Properties
    static let storyboardIdentifier = "SearchResultsViewController"
    
    let url : String = "https://itunes.apple.com/search?term=%@&country=US&entity=software"
    
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AppTableViewCell
        // Configure the cell...
        guard let app : AppModel = dataArray[(indexPath as NSIndexPath).row] as AppModel? else { print("no value") }
        
        let viewModel = AppViewModel()
        cell.configure(withDataSource: app, delegate: viewModel)
        
        return cell
    }
    
}


//MARK: - AlamofireSearchAPI -> MainTableViewController Extension
typealias AlamofireSearchAPI = MainTableViewController
extension AlamofireSearchAPI {
    
    /// get data from search
    func getDataFromSearch(_ keyword:String) {
        // make an instance
        let searchUrl : String = String(format: url, keyword)
        
        // alamofire prepare request
        Alamofire
            .request(
            searchUrl,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
            )
        // response Json
        .responseJSON { (response) in

            // check if any data exists
            guard response.result.value != nil else {
                return self.showAlertController()
            }
            
            do {
                // json serialization
                let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                
                // get "results" array
                if let key = json as AnyObject?, let results = key.object(forKey: "results") as? NSArray {
                    
                    if results.count > 0 {
                        
                        // remove all elements
                        self.dataArray.removeAll(keepingCapacity: true)
                        
                        // prepare values
                        for key in results {
                            
                            if let dict = key as? NSDictionary {
                                
                                let name = dict.value(forKey:"trackName") as! String
                                let desc = dict.value(forKey:"description") as! String
                                let thum = dict.value(forKey:"artworkUrl60") as! String
                                let urls = dict.value(forKey:"trackViewUrl") as! String
                                let sell = dict.value(forKey:"sellerName") as! String
                                
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
            } catch _ {
                // something went wrong or data unavailable
                self.showAlertController()
            }
        }
    }
    
    /// show simple alert controller
    func showAlertController() {
        let title = NSLocalizedString("No Results founded", comment: "")
        let message = NSLocalizedString("No Apps!", comment: "")
        let acceptButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the action.
        let acceptAction = UIAlertAction(title: acceptButtonTitle, style: .default) { _ in
            print("The simple alert's accept action occurred.")
        }
        
        // Add the action.
        alertController.addAction(acceptAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - MainSearchController -> MainTableViewController Extension
typealias MainSearchController = MainTableViewController
extension MainSearchController : UISearchControllerDelegate, UISearchResultsUpdating {
    
    /// UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
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
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
