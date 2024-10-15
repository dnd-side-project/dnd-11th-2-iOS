//
//  RunningRecord.swift
//  RunUs
//
//  Created by seungyooooong on 9/26/24.
//

import Foundation

struct RunningRecord: Navigatable {
    let runningRecordId: Int
    let startLocation: String
    let endLocation: String
    let emotion: String
    let runningData: RunningResultData
}
