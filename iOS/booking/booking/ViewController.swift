//
//  ViewController.swift
//  booking
//
//  Created by euwang on 10/15/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View has loaded!")
        
        guard let url = URL(string: "https://apple.com") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                print("Received HTML: \(htmlString.prefix(2000))") // Print first 200 characters
            }
        }
        task.resume()
    }
    
}

