//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

//UISearchResultsUpdating
class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var searchController: UISearchController!
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filteredData: [Business]!
    //var isMoreDataLoading = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        //searchBar = UISearchBar()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        //searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        //searchController.hidesNavigationBarDuringPresentation = false
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onCustomTap:")
        tapGestureRecognizer.numberOfTapsRequired = 2
        
        tableView.userInteractionEnabled = true
        tableView.addGestureRecognizer(tapGestureRecognizer)

        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        Business.searchWithTerm("Food", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        /*
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }*/
        })

        
        
        

        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if filteredData != nil{
            return filteredData.count
        }else{
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        //cell.business = businesses[indexPath.row]
        cell.business = filteredData[indexPath.row]
        
        return cell
    }
    
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? filteredData : businesses.filter({(dataItem: Business) -> Bool in
            return dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        self.tableView.reloadData()
    }
    */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = businesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = searchText.isEmpty ? filteredData : businesses.filter({(dataItem: Business) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
        //self.tableView.reloadData()
    }
    
 
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func onCustomTap(sender: UITapGestureRecognizer) {
        var point = sender.locationInView(tableView)
        searchBar.text = ""
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
        
        // User tapped at the point above. Do something with that if you want.
    }
    /*
    func loadMoreData() {
   
        self.isMoreDataLoading = false
        
        Business.searchWithTerm("Food", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
            /*
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }*/
        })

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                loadMoreData()
            }
        }
    }

    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
