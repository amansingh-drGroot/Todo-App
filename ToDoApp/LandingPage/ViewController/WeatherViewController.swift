//
//  WeatherViewController.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import UIKit
import CoreLocation
import RxSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var tempTypeLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    @IBOutlet weak var windHumidLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var todoNavigationButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var selectedUser: User?
    private let locationManager = CLLocationManager()
    private let weatherViewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    private var forecastData: ForecastModel?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configTheme()
        configDependency()
        configAPiRequests()
    }
    
    private func configTheme() {
        
        self.nameLabel.customLabel(
            text: "Hello!, \(self.selectedUser?.name ?? "")",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        )
        
        self.idLabel.customLabel(
            text: "User Id: \(self.selectedUser?.id ?? 0)",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 13, weight: .semibold)
        )
        
        self.locationLabel.customLabel(
            text: "Lucknow",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 25, weight:    .semibold)
        )
        self.currentTempLabel.customLabel(
            text: "",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 50, weight: .semibold)
        )
        self.tempTypeLabel.customLabel(
            text: "",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )
        self.latLongLabel.customLabel(
            text: "",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )

        self.windHumidLabel.customLabel(
            text: "",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: .regular)
        )
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.todoNavigationButton.customButton(title: "Let's Check ToDo", titleFont: UIFont.systemFont(ofSize: 20, weight: .medium), textColor: .black, cornerRadius: 12, backgroundColor: .lightGray)
    }
    
    private func configDependency() {
        
        // Table view
        self.weatherTableView.separatorStyle = .none
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        self.weatherTableView.register(UINib(nibName: "WeatherDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherDetailTableViewCell")
        
        // Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func configAPiRequests() {
        
        weatherViewModel.forecastRequestStatus.asObservable().bind(
            onNext: { status in
                switch status {
                case .idle:
                    print("Forecast API IDLE")
                case .progress:
                    print("Forecast API In Progress")
                    self.activityIndicator.startAnimating()
                case .success:
                    print("Success Forecast API")
                    self.activityIndicator.stopAnimating()
                case .error(message: let message):
                    print(message ?? "")
                    Utility.shared.showAlert(
                        title: "",
                        message: message ?? "Unable to load data!",
                        buttons: [.retry]
                    )
                self.activityIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        weatherViewModel.forecaseRequestData.asObservable().bind(onNext: { data in
            self.forecastData = data
            self.setForecastData()
        }).disposed(by: disposeBag)
    }
    
    private func setForecastData() {
        
        if let data = forecastData {
            self.currentTempLabel.customLabel(
                text: "\(data.current?.temperature2M ?? 0) \(data.currentUnits?.temperature2M ?? "")",
                textColor: .black,
                font: UIFont.systemFont(ofSize: 50, weight: .semibold)
            )
            self.latLongLabel.customLabel(
                text: "Lat:\(data.latitude ?? 0)  Long: \(data.longitude ?? 0)",
                textColor: .black,
                font: UIFont.systemFont(ofSize: 15, weight: .regular)
            )

            self.windHumidLabel.customLabel(
                text: "Wind: \(data.current?.windSpeed10M ?? 0) \(data.currentUnits?.windSpeed10M ?? "")  Humidity: \(data.current?.relativeHumidity2M ?? 0) \(data.currentUnits?.relativeHumidity2M ?? "")",
                textColor: .black,
                font: UIFont.systemFont(ofSize: 15, weight: .regular)
            )
            
            self.tempTypeLabel.customLabel(
                text: "Timezone: \(data.timezone ?? "")",
                textColor: .black,
                font: UIFont.systemFont(ofSize: 15, weight: .regular)
            )
        }
        
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
    
    @IBAction func didTapToDoNavigationButton(_ sender: UIButton) {
        let landingSB = UIStoryboard(name: "LandingPage", bundle: nil)
        let todoVC = landingSB.instantiateViewController(withIdentifier: "ToDoViewController") as! ToDoViewController
        todoVC.modalPresentationStyle = .formSheet
        todoVC.selectedUser = self.selectedUser
        self.present(todoVC, animated: true)
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.forecastData?.hourly?.time?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherDetailCell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell") as! WeatherDetailTableViewCell
        if indexPath.row == 0 {
            weatherDetailCell.setDetailCell(time: "Time (HH:MM)", temp: "Temperature (\(self.forecastData?.hourlyUnits?.temperature2M ?? ""))", humid: "Humid (\(self.forecastData?.hourlyUnits?.relativeHumidity2M ?? ""))", windSpeed: "Wind Speed (\(self.forecastData?.hourlyUnits?.windSpeed10M ?? ""))", weight: .semibold)
        } else {
            weatherDetailCell.setDetailCell(time: Date.time(from: self.forecastData?.hourly?.time?[indexPath.row - 1] ?? "") ?? "", temp: "\(self.forecastData?.hourly?.temperature2M?[indexPath.row - 1] ?? 0)", humid: "\(self.forecastData?.hourly?.relativeHumidity2M?[indexPath.row - 1] ?? 0)", windSpeed: "\(self.forecastData?.hourly?.relativeHumidity2M?[indexPath.row - 1] ?? 0)", weight: .regular)
        }
        weatherDetailCell.selectionStyle = .none
        return weatherDetailCell
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude

        self.weatherViewModel.callForecastApi(latitude: "\(latitude)", longitude: "\(longitude)", current: "temperature_2m,wind_speed_10m,relative_humidity_2m", hourly: "temperature_2m,relative_humidity_2m,wind_speed_10m")
    }
}
