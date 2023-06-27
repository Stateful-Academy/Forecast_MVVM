//
//  DayDetailsViewController.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/13/22.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    /// MVC
    var forcastData: TopLevelDictionary?
    var days: [Day] = []
    /// MVC
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Conform to the TBVS Protocols
        dayForcastTableView.dataSource = self
        
        /// MVC
        NetworkingController.fetchDays { result in
            switch result {
            case .success(let forcastData):
                self.forcastData = forcastData
                self.days = forcastData.days
                DispatchQueue.main.async {
                    self.configureView()
                    self.dayForcastTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching the data!", error.errorDescription!)
            }
        }
        /// MVC
    }
    
    func configureView() {
        let currentDay = days[0]
        cityNameLabel.text = forcastData?.cityName ?? "No City Found"
        currentDescriptionLabel.text = currentDay.weather.description
        currentTempLabel.text = "\(currentDay.temp)F"
        currentLowLabel.text = "\(currentDay.lowTemp)F"
        currentHighLabel.text = "\(currentDay.highTemp)F"
    }
}


//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forcastData?.days.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        let day = days[indexPath.row]
        cell.updateViews(day: day)
        return cell
    }
}


