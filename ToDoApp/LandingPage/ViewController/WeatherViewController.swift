//
//  WeatherViewController.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var tempTypeLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    @IBOutlet weak var windHumidLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configTheme()
        configDependency()
    }

    private func configTheme() {
        
        self.locationLabel.customLabel(
            text: "Delhi",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 25, weight:    .semibold)
        )
        self.currentTempLabel.customLabel(
            text: "45",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 50, weight: .semibold)
        )
        self.tempTypeLabel.customLabel(
            text: "Mostly Moderate",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )
        self.latLongLabel.customLabel(
            text: "Lat: 77  Long: 48",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )
        self.latLongLabel.customLabel(
            text: "Lat: 77  Long: 48",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )
        self.windHumidLabel.customLabel(
            text: "Wind: 25 km/h  Humidity: 60%",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )
    }
    
    private func configDependency() {
        
        self.weatherTableView.separatorStyle = .none
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        self.weatherTableView.register(UINib(nibName: "WeatherDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherDetailTableViewCell")
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherDetailCell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell") as! WeatherDetailTableViewCell
        weatherDetailCell.setDetailCell(time: "Time", temp: "Temperature", humid: "Humid", windSpeed: "Wind Speed")
        weatherDetailCell.selectionStyle = .none
        return weatherDetailCell
    }
    
}
