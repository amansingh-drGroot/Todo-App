//
//  WeatherViewModel.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class WeatherViewModel {
    
    let forecastRequestStatus: BehaviorRelay<ApiRequestStatus> = BehaviorRelay<ApiRequestStatus>(value: .idle)
    let forecaseRequestData: BehaviorRelay<ForecastModel?> = BehaviorRelay<ForecastModel?>(value: nil)
    private let disposeBag = DisposeBag()
    
    func callForecastApi(latitude: String, longitude: String, current: String, hourly: String) {
        forecastRequestStatus.accept(.progress)
        MoyaServiceProvider.weatherService.rx.request(
            .forecast(
                latitude: latitude,
                longitude: longitude,
                current: current,
                hourly: hourly
            )
        ).subscribe(
            on: MainScheduler.instance
        ).filterSuccessfulStatusCodes()
            .subscribe({ [weak self] event in
                switch event {
                case let .success(response):
                    do {
                        let data = try JSONDecoder().decode(ForecastModel.self, from: response.data)
                        self?.forecaseRequestData.accept(data)
                    } catch {
                        print("Getting error while decoding data")
                    }
                    self?.forecastRequestStatus.accept(.success)
                case let .failure(error):
                    self?.forecastRequestStatus.accept(.error(message: "\(error)"))
                }
            }).disposed(by: disposeBag)
    }
}
