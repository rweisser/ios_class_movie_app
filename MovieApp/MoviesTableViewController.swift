//
//  MoviesTableViewController.swift
//  MovieApp
//
//  Created by Robert Weisser on 10/18/15.
//  Copyright © 2015 Robert Weisser. All rights reserved.
//

private let kMovieCell   = "movieCell"
private let kPosterSegue = "posterSegue"

import UIKit

class MoviesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    var moviesDataSource = [Movie]()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kMovieCell, forIndexPath: indexPath)

        cell.textLabel?.text = moviesDataSource[indexPath.row].name
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kPosterSegue, sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kPosterSegue {
            if let posterController = segue.destinationViewController as? PosterViewController {
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    let movie = moviesDataSource[selectedIndex.row]
                    posterController.movie = movie
                }
            }
        }
    }
}
