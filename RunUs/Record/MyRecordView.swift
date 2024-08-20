//
//  MyRecordView.swift
//  RunUs
//
//  Created by seungyooooong on 8/18/24.
//

import SwiftUI

struct MyRecordView: View {
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            myRecordView
            ScrollView {
                myRecordView
            }
        }
        .padding(.top, 1)   // MARK: ViewThatFits에서 ScrollView를 사용하면 SafeArea를 유지하기 위해 필요
        .background(Color.background)
    }
}

extension MyRecordView {
    private var myRecordView: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(userName)님")
                        .font(Fonts.pretendardBold(size: 20))
                    Spacer()
                    HStack {
                        Text("현재까지 20Km를 달렸어요!")    // TODO: '20Km' 수정 필요
                    }
                    Text("Level 2 까지 5Km 남았어요!")    // TODO: 'Level 2' & '5Km' 수정 필요
                }
                .font(Fonts.pretendardMedium(size: 14))
                Spacer()
                Image(.splash)  // TODO: 서버에서 받는 이미지 URL로 수정 필요
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxHeight: 86)
            .padding(.top, 48)
            .padding(.bottom, 30)
            recordMenus
                .padding(.bottom, 30)
            MyRecordButton(action: {
                // TODO: 나의 뱃지 화면으로 이동
            }, text: "나의 뱃지")
            .padding(.bottom, 18)
            MyBadges(badges: [])    // TODO: 서버에서 받는 뱃지 리스트로 수정 필요
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 8)
                .background(.mainDeepDark)
                .padding(.horizontal, -Paddings.outsideHorizontalPadding)
                .padding(.bottom, 12)
            MyRecordButton(action: {
                // TODO: Logout 기능 구현
            }, text: "로그아웃")
            MyRecordButton(action: {
                // TODO: 회원 탈퇴 기능 구현
            }, text: "회원 탈퇴")
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
    
    private var recordMenus: some View {
        HStack {
            RecordMenu(RecordMenuObject(RecordMenus.runningRecord))
            recordDivider
            RecordMenu(RecordMenuObject(RecordMenus.runningSummary))
            recordDivider
            RecordMenu(RecordMenuObject(RecordMenus.achieveRecord))
        }
        .frame(height: 102)
        .background(.mainDeepDark)
        .cornerRadius(12)
    }
    
    private var recordDivider: some View {
        Divider()
            .frame(width: 1, height: 45)
            .background(.white)
    }
}

#Preview {
    MyRecordView()
}
