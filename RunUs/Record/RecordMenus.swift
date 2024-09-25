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
}

struct RecordMenuObject {
    let recordMenu: RecordMenus
    let text: String
    let icon: ImageResource
    
    init(_ recordMenu: RecordMenus) {
        self.recordMenu = recordMenu
        switch recordMenu {
        case .runningRecord:
            self.text = "운동기록"
            self.icon = .runningRecord
        case .runningSummary:
            self.text = "활동요약"
            self.icon = .runningSummary
        case .achieveRecord:
            self.text = "달성기록"
            self.icon = .achieveRecord
        }
    }
}

struct RecordMenu: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let recordMenuObject: RecordMenuObject
    let profile: ProfileResponseModel
    
    init(_ recordMenuObject: RecordMenuObject, _ profile: ProfileResponseModel = ProfileResponseModel()) {
        self.recordMenuObject = recordMenuObject
        self.profile = profile
    }
    
    var body: some View {
        Button {
            switch self.recordMenuObject.recordMenu {
            case .runningRecord:
                let navigationObject = NavigationObject(viewType: .runningRecord)
                viewEnvironment.navigationPath.append(navigationObject)
                break
            case .runningSummary:
                // TODO: 활동요약화면으로 이동
                break
            case .achieveRecord:
                let navigationObject = NavigationObject(viewType: .achieveRecord, data: profile)
                viewEnvironment.navigationPath.append(navigationObject)
            }
        } label: {
            VStack {
                Image(recordMenuObject.icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.bottom, 19)
                Text(recordMenuObject.text)
                    .font(Fonts.pretendardMedium(size: 14))
                    .foregroundColor(.gray200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
