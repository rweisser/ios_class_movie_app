//
//  ViewController.swift
//  MovieApp
//
//  Created by Robert Weisser on 10/15/15.
//  Copyright © 2015 Robert Weisser. All rights reserved.
//

import UIKit

private let kShowMoviesSegue = "showMoviesSegue"

class ViewController: UIViewController {

    @IBOutlet weak var textSearchCriteria: UITextField!
    
    var moviesDataSource = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
        
        // pass movie names to MovieTableViewController
        if segue.identifier == kShowMoviesSegue {
            if let movieController = segue.destinationViewController as?
                MoviesTableViewController {
                    movieController.moviesDataSource = self.moviesDataSource
            }            
        }
    }

    @IBAction func findMovies(sender: AnyObject) {
        
        let criteria = textSearchCriteria.text!
        let escapedCriteria =
            criteria.stringByAddingPercentEncodingWithAllowedCharacters(
                NSCharacterSet.URLHostAllowedCharacterSet())!


        let urlString = "http://www.omdbapi.com/?s=\(escapedCriteria)"
        
        // URL obj.
        if let url = NSURL(string: urlString) {
            
            // url request
            let request = NSURLRequest(URL: url)
            
            // sharedSession() returns a singleton
            // dataTaskWithRequest creates an asyncronous network request
            // data is result, response is i.e. HTTP 200, error is complicated
            let task = NSURLSession.sharedSession()
                .dataTaskWithRequest(request) {
                    
                [weak self] (data, response, error) -> Void
                in
                if let _self = self {   // WHY?
                    // FIXME: -- Handle your errors!  LOOK IT UP!
                    if let data = data  where error == nil {
                        let json =
                            try! NSJSONSerialization.JSONObjectWithData(
                                data, options: [])
                        
                        // transform JSON into an array of Movie objects
                        let parsedMovies = Movie.parseMovieJSON(json)
                        
                        // Back to main thread:
                        dispatch_async(dispatch_get_main_queue(), {
                            () -> Void
                            in
                            _self.moviesDataSource.removeAll()
                            _self.moviesDataSource = parsedMovies
                            _self.performSegueWithIdentifier(kShowMoviesSegue,
                                sender: nil)
                        })
                    }
                }
            }
            task.resume()
        }
    }
}

