//
//  ServerEndpoint.swift
//  RunUs
//
//  Created by Ryeong on 7/24/24.
//

import Foundation

//TODO: Server 나오면 수정
enum ServerEndpoint: NetworkEndpoint {
    case test
    
    var baseURL: URL? { nil }
    var path: String { "" }
    var method: NetworkMethod { .get }
    var parameters: [URLQueryItem]? { nil }
    var header: [String : String]? { nil }
    var body: Data? { nil }
}
