//
//  MyRecordView.swift
//  RunUs
//
//  Created by seungyooooong on 8/18/24.
//

import SwiftUI
import ComposableArchitecture

struct MyRecordView: View {
    @EnvironmentObject var alertEnvironment: AlertEnvironment
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    @State var store: StoreOf<MyRecordStore> = Store(
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
        .onAppear {
            store.send(.onAppear)
            store.send(.mapAuthorizationPublisher)
        }
    }
}

extension MyRecordView {
    private var myRecordView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 48)
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .frame(maxHeight: 86)
            Spacer().frame(height: 30)
            recordMenus
            Spacer().frame(height: 30)
            RUTitle(text: "나의 뱃지")  // TODO: 추후 RUTitle -> RUTitleButton 수정 필요 (나의 뱃지 화면으로 이동)
            Spacer().frame(height: 12)
            MyBadges(badges: store.badges)
            Rectangle()
                .fill(.mainDeepDark)
                .frame(maxWidth: .infinity)
                .frame(height: 8)
                .padding(.horizontal, -Paddings.outsideHorizontalPadding)
            Spacer().frame(height: 12)
            RUTitleButton(action: {
                alertEnvironment.showAlert(title: "로그아웃 하시겠습니까?", mainButtonText: "로그아웃", mainButtonAction: logout)
            }, text: "로그아웃")
            RUTitleButton(action: {
                alertEnvironment.showAlert(title: "정말 탈퇴 하시겠습니까?", subTitle: "탈퇴할 경우 모든 데이터가 삭제되고\n복구가 불가능합니다.", mainButtonText: "탈퇴하기", mainButtonColor: .red, mainButtonAction: withdraw)
            }, text: "회원 탈퇴")
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
    
    private var recordMenus: some View {
        HStack {
            RecordMenu(.runningRecord)
            recordDivider
            RecordMenu(.runningSummary)
            recordDivider
            RecordMenu(.achieveRecord, store.profile)
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
    
    private func logout() {
        store.send(.logout)
        alertEnvironment.dismiss()
    }
    
    private func withdraw() {
        store.send(.appleLoginForWithdraw)
        alertEnvironment.dismiss()
    }
}

#Preview {
    MyRecordView()
}
