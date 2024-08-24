//
//  MyRecordView.swift
//  RunUs
//
//  Created by seungyooooong on 8/18/24.
//

import SwiftUI
import ComposableArchitecture

struct MyRecordView: View {
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    let store: StoreOf<MyRecordStore> = Store(
        initialState: MyRecordStore.State(),
        reducer: { MyRecordStore() }
    )
    
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
                    HStack(spacing: 0) {
                        Text("현재까지 ")
                        Text(store.profile.currentKm)
                            .font(Fonts.pretendardBold(size: 14))
                            .foregroundColor(.mainGreen)
                        Text("를 달렸어요!")
                    }
                    Text("\(store.profile.nextLevelName) 까지 \(store.profile.nextLevelKm) 남았어요!")
                }
                .font(Fonts.pretendardMedium(size: 14))
                Spacer()
                AsyncImage(url: URL(string: store.profile.profileImageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100, maxHeight: .infinity) // MARK: 임의 Width 사용
                }
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
            MyBadges(badges: store.badges)
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
        .onAppear {
            store.send(.onAppear)
        }
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
