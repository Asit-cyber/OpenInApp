//
//  ViewController.swift
//  openInAppDemo
//
//  Created by ASIT GHATAK on 29/04/24.
//
import Foundation
import UIKit
import Charts

class ViewController: UIViewController {
    var greeting = ""
    let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew")!
    var todayClicks: Int?
    var topLocation: String?
    var topSource: String?
//    var json: [String: Any]?
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var lineChart: UIView!
    @IBOutlet weak var todayClick: UIView!
    @IBOutlet weak var top_Location: UIView!
    @IBOutlet weak var top_Source: UIView!
    @IBOutlet weak var tClick: UILabel!
    @IBOutlet weak var tLocation: UILabel!
    @IBOutlet weak var tSource: UILabel!
    @IBOutlet weak var analyticsButton: UIButton!
    @IBOutlet weak var searchBarMic: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var stackToPopulateData: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var greet: UILabel!
    @IBOutlet weak var greetingField: UITextField!
//    var linkDataArray = [Model]()
    var linkDataArray: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContainer.layer.cornerRadius = 20
        lineChart.layer.cornerRadius = 20
        todayClick.layer.cornerRadius = 10
        top_Location.layer.cornerRadius = 10
        analyticsButton.layer.cornerRadius = 15
        analyticsButton.layer.borderWidth = 0.5
        analyticsButton.layer.borderColor = UIColor.black.cgColor
        
        top_Source.layer.cornerRadius = 10
        setGreeting()
        greet.text = greeting + " Hi Asit"
        fetchData()
        
        searchBarMic.showsBookmarkButton = false
        segmentController.setTitle("Top Links", forSegmentAt: 0)
        segmentController.setTitle("Recent Links", forSegmentAt: 1)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DataCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cellRow")
    }
  
    func fetchData() {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            // Check if response contains data
            guard let data = data else {
                print("No data received")
                return
            }
            // Parse the data (assuming it's JSON for now)
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if json == nil {
                    print("Error parsing JSON")
                    return
                }
//                print("JSON Response: \(json)")
                // Extract required values from the JSON object
                self.todayClicks = json?["today_clicks"] as? Int
                self.topLocation = json?["top_location"] as? String
                self.topSource = json?["top_source"] as? String
                    
                // Update UI on the main thread
                DispatchQueue.main.async {
                    // Update labels with fetched data
                    if let clicks = self.todayClicks {
                        let clicksString = String(clicks)
                        self.tClick.text = clicksString
                    } else {
                        self.tClick.text = "No data available"
                    }
                    self.tLocation.text = self.topLocation
                    self.tSource.text = self.topSource
                    
                    //Populate Stack view//
                    if let dataJsn = json?["data"] as? [String: Any],
                        let recentLinks = dataJsn["recent_links"] as? [[String: Any]] {
//                        print("Recent links: \(recentLinks)")
                        print("1====================================================")
                        for link in recentLinks {
                            if let createdAtString = link["created_at"] as? String,
                               let totalClicks = link["total_clicks"] as? Int,
                               let originalImageString = link["original_image"] as? String,
                               let originalImageURL = URL(string: originalImageString) {
                                let formattedDate = self.formatDate(from: createdAtString)
//                                print("Total Click = \(totalClicks)")
//                                print("=======================================================")
//                                print("Date = " + formattedDate)
//                                print("Image url =  \(originalImageURL)")
                                let linkData = Model(sampleLink: "https://samplelink.com", totalClicks: "\(totalClicks)", formattedDate: "\(formattedDate)", originalImageURL: originalImageString)
                                self.linkDataArray.append(linkData)
                            }
                        }
//                        print("2====================================================")
                    }
                }
            }
        }
        // Resume the task to start the request
        task.resume()
    }

    
    func setGreeting() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: Date())) ?? 0
        
        if hour < 12 {
            greeting = "Good Morning"
        } else if hour < 18 {
            greeting = "Good Afternoon"
        } else {
            greeting = "Good Evening"
        }
    }
    
    // Function to format date string
   func formatDate(from dateString: String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       if let date = dateFormatter.date(from: dateString) {
           dateFormatter.dateFormat = "dd MMM yyyy"
           return dateFormatter.string(from: date)
       }
       return ""
   }
    
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRow", for: indexPath)
        as! DataCellTableViewCell
        cell.currDate.text = "1 May 24"

//        print("333====================================================")
//            let linkData = linkDataArray[indexPath.row]
//            cell.currDate.text = linkData.formattedDate
//            cell.clicks.text = linkData.totalClicks
//               // Load image from URL asynchronously
////               cell.logo.load(url: linkData.originalImageURL)
//            cell.link.text = linkData.sampleLink
//        print("Total Click = \(linkData.totalClicks)")
//        print("Date = \(linkData.formattedDate)")
//        print("Image url =  \(linkData.originalImageURL)")
//        print("444=======================================================")
        return cell
    }
    
    
}
