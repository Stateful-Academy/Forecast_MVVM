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
    var viewModel: DayDetailViewModel!
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DayDetailViewModel(delegate: self)
        // Conform to the TableViewDataSource Protocol
        dayForcastTableView.dataSource = self
    }
    
    private func configureView() {
        let currentDay = viewModel.days[0]
        self.cityNameLabel.text = viewModel.forcastData?.cityName ?? "No City Found"
        currentDescriptionLabel.text = currentDay.weather.description
        currentTempLabel.text = "\(currentDay.temp)F"
        currentLowLabel.text = "\(currentDay.lowTemp)F"
        currentHighLabel.text = "\(currentDay.highTemp)F"
        dayForcastTableView.reloadData()
    }
} // End

//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        let day = viewModel.days[indexPath.row]
        cell.updateViews(day: day)
        return cell
    }
}

extension DayDetailsViewController: DayDetailViewDelegate {
    func forecastDataLoadedSuccessfully() {
        DispatchQueue.main.async { [weak self] in
            self?.configureView()
        }
    }
}

