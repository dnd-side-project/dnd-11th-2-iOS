//
//  HomeView.swift
//  RunUs
//
//  Created by seungyooooong on 7/23/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @AppStorage(UserDefaultKey.name.rawValue) var userName: String = "런어스"
    @State var store: StoreOf<HomeStore>
    
    var body: some View {
        ScrollView {
            homeView
        }
        .refreshable {
            store.send(.refresh)
        }
        .padding(.top, 1)   // MARK: SafeArea를 유지하기 위해 필요
        .background(Color.background)
        .onAppear {
            store.send(.mapGetWeatherPublisher)
        }
    }
}

extension HomeView {
    private var homeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 20)
            Button {
                store.send(.refresh)
            } label: {
                Image(.Home.runus)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
            }
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 0) {
                        Text("\(userName)님")
                            .foregroundStyle(.mainGreen)
                        Text(",")
                    }
                    Text("오늘도 힘내서 달려볼까요?")
                }
                .font(Fonts.pretendardBold(size: 20))
                Spacer()
                AsyncImage(url: URL(string: store.weather.weatherIconUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 136, height: 102)
            }
            .frame(height: 102)
            .padding(.trailing, -Paddings.outsideHorizontalPadding)
            Spacer().frame(height: 39)
            HStack(alignment: .bottom, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 0) {
                        Image(.Home.location)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                            .padding(.horizontal, 1)
                        Text(store.currentLocatoin).font(Fonts.pretendardRegular(size: 12))
                    }
                    .frame(height: 20)
                    Text(store.weather.weatherName)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    HStack(spacing: 4) {
                        Text("체감온도 \(store.weather.apparentTemperature)℃")
                        Text("\(store.weather.maxTemperature)℃/\(store.weather.minTemperature)℃")
                            .foregroundStyle(.gray300)
                    }
                    .font(Fonts.pretendardRegular(size: 12))
                }
                Text(store.weather.weatherDescription)
                    .lineSpacing(8)
                    .foregroundStyle(.gray100)
                    .font(Fonts.pretendardRegular(size: 12))
            }
            Spacer().frame(height: 28)
            RUTitleButton(action: {
                viewEnvironment.selectedTabItem = .running
                viewEnvironment.selectedRunningMode = .goal
            }, text: "오늘의 러닝 챌린지 및 목표설정")
            RUChallengeList(
                selectedChallengeIndex: $store.selectedChallengeIndex,
                challenges: $store.challenges,
                selectAction: selectAction,
                listHorizontalPadding: Paddings.outsideHorizontalPadding,
                scrollHorizontalPadding: -Paddings.outsideHorizontalPadding,
                itemHasShadow: false,
                itemBackgroundColor: .mainDeepDark
            )
            Spacer().frame(height: 36)
            RUTitle(text: "이번 달 러닝 기록")
            VStack(alignment: .leading, spacing: 0) {
                Text("\(store.monthlySummary.month)에는")
                Spacer().frame(height: 4)
                HStack(spacing: 0) {
                    Text(store.monthlySummary.monthlyKm)
                        .foregroundStyle(.mainGreen)
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text(" 달렸어요")
                    Spacer()
                }
                Spacer().frame(height: 10)
                Text("\(store.monthlySummary.nextLevelName)까지 \(store.monthlySummary.nextLevelKm) 남았어요!")
                    .font(Fonts.pretendardRegular(size: 12))
            }
            .font(Fonts.pretendardMedium(size: 16))
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(.mainDeepDark)
            .cornerRadius(12)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
    }
    
    private func selectAction(selectedChallengeIndex: Int) {
        viewEnvironment.selectedTabItem = .running
        viewEnvironment.selectedRunningMode = .challenge
        store.send(.selectChallenge(selectedChallengeIndex))
    }
}
