//
//  PosterViewController.swift
//  MovieApp
//
//  Created by Robert Weisser on 10/18/15.
//  Copyright © 2015 Robert Weisser. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = movie?.name
        fetchPhoto()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPhoto() {
        if let movie = movie {
            let urlString = movie.imageUrlString
            if urlString == "N/A" {
                // No poster available
                return
            }
            let url = NSURL(string: urlString)!
            let urlRequest = NSURLRequest(URL: url)            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: {
                [weak self] (data, response, error) -> Void
                in
                if let _self = self {
                    // FIXME: -- Handle errors!
                    if let data = data where error == nil {
                        let image = UIImage(data: data)
                        dispatch_async(dispatch_get_main_queue(), {
                            () -> Void
                            in
                            _self.posterImageView.image = image
                        })
                    }
                }
            })
            task.resume()
        }
    }
}
