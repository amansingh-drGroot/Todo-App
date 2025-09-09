//
//  WeatherDetailTableViewCell.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setDetailCell(time: String, temp: String, humid: String, windSpeed: String, weight: UIFont.Weight) {
      
        self.timeLabel.customLabel(
            text: time,
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: weight)
        )
        self.tempLabel.customLabel(
            text: temp,
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: weight)
        )
        self.humidLabel.customLabel(
            text: humid,
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: weight)
        )
        self.windSpeedLabel.customLabel(
            text: windSpeed,
            textColor: .black,
            font: UIFont.systemFont(ofSize: 15, weight: weight)
        )
    }
   
}
