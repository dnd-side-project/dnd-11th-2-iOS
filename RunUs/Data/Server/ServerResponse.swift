//
//  ServerResponse.swift
//  RunUs
//
//  Created by Ryeong on 7/23/24.
//

import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: ServerError?
}

struct EmptyData: Decodable { }

struct ServerError: Decodable {
    let statusCode: Int
    let code: String
    let message: String
}
