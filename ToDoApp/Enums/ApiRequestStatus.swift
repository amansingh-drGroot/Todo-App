//
//  ApiRequestStatus.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//


enum ApiRequestStatus: Equatable {
    case idle
    case progress
    case success
    case error(message: String?)
}
