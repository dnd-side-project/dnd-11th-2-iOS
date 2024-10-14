//
//  RecordMenus.swift
//  RunUs
//
//  Created by seungyooooong on 8/19/24.
//

import Foundation
import SwiftUI

enum RecordMenus {
    case runningRecord
    case runningSummary
    case achieveRecord
    
    var text: String {
        switch self {
        case .runningRecord:
            return "운동기록"
        case .runningSummary:
            return "활동요약"
        case .achieveRecord:
            return "달성기록"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .runningRecord:
            return .runningRecord
        case .runningSummary:
            return .runningSummary
        case .achieveRecord:
            return .achieveRecord
        }
    }
}

struct RecordMenu: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let recordMenu: RecordMenus
    let profile: ProfileResponseModel
    
    init(_ recordMenu: RecordMenus, _ profile: ProfileResponseModel = ProfileResponseModel()) {
        self.recordMenu = recordMenu
        self.profile = profile
    }
    
    var body: some View {
        Button {
            switch self.recordMenu {
            case .runningRecord:
                let navigationObject = NavigationObject(viewType: .runningRecord)
                viewEnvironment.navigationPath.append(navigationObject)
                break
            case .runningSummary:
                let navigationObject = NavigationObject(viewType: .runningSummary)
                viewEnvironment.navigationPath.append(navigationObject)
                break
            case .achieveRecord:
                let navigationObject = NavigationObject(viewType: .achieveRecord, data: profile)
                viewEnvironment.navigationPath.append(navigationObject)
            }
        } label: {
            VStack(spacing: 0) {
                Image(recordMenu.icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                Spacer().frame(height: 19)
                Text(recordMenu.text)
                    .font(Fonts.pretendardMedium(size: 14))
                    .foregroundColor(.gray200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
