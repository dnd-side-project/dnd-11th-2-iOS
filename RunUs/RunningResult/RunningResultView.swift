//
//  RunningResultView.swift
//  RunUs
//
//  Created by Ryeong on 8/23/24.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct RunningResultView: View {
    @State var store: StoreOf<RunningResultFeature>
    let navigationButtonType: NavigationButtonType
    
    init(runningResult: RunningResult) {
        self.store = Store(initialState: RunningResultFeature.State(runningResult: runningResult), reducer: { RunningResultFeature() })
        self.navigationButtonType = .home
    }
    init(runningRecord: RunningRecord) {
        self.store = Store(initialState: RunningResultFeature.State(runningRecord: runningRecord), reducer: { RunningResultFeature() })
        self.navigationButtonType = .back
    }
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            runningResultView
            ScrollView {
                runningResultView
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 1)   // MARK: SafeArea를 유지하기 위해 필요
        .foregroundStyle(.white)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .background(Color.background)
        .onAppear{
            store.send(.onAppear)
        }
    }
}

extension RunningResultView {
    private var runningResultView: some View {
        VStack(alignment: .leading, spacing: 0) {
            RUNavigationBar(buttonType: navigationButtonType, title: "러닝결과")
            Spacer().frame(height: 26)
            Text("\(store.date)")
                .font(Fonts.pretendardMedium(size: 14))
            Spacer().frame(height: 15)
            emotionView
            if let achievementResult = store.achievementResult {
                Spacer().frame(height: 26)
                RUTitle(text: "\(store.achievementMode == .challenge ? "오늘의 러닝 챌린지" : "오늘의 러닝 목표")", textSize: 20)
                achievementView(achievementResult)
            }
            Spacer().frame(height: 28)
            RUTitle(text: "오늘의 러닝 페이스", textSize: 20)
            resultView
            if let routes = store.routes {
                Spacer().frame(height: 26)
                RUTitle(text: "오늘의 러닝 코스", textSize: 20)
                runningCourseView(routes)
            }
            Spacer()
        }
    }
    
    private var emotionView: some View {
        HStack(spacing: 16) {
            Image(store.state.emotion.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text("\(store.state.emotion.text)")
                .font(Fonts.pretendardBold(size: 16))
                .foregroundStyle(.white)
            Spacer()
        }
    }
    
    private func achievementView(_ achievementResult: AchievementResult) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 10) {
                AsyncImage(url: URL(string: achievementResult.iconUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(achievementResult.title)")
                        .font(Fonts.pretendardSemiBold(size: 16))
                    Text("\(achievementResult.subTitle)")
                        .font(Fonts.pretendardRegular(size: 12))
                }
            }
            RUProgress(percent: achievementResult.percentage)
        }
        .grayscale(achievementResult.isSuccess ? 0 : 1)
        .padding(.horizontal, Paddings.outsideHorizontalPadding)
        .padding(.vertical, 20)
        .background(.mainDeepDark)
        .cornerRadius(12)
    }

    private var resultView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text(store.distance.kmDistanceFormat)
                    .font(Fonts.pretendardBlack(size: 84))
                    .padding(.top, -10) // MARK: 텍스트 윗 공간 여백을 줄여 UI를 맞추기 위한 임시 처리
                smallText("킬로미터")
            }
            Spacer().frame(height: 32)
            HStack {
                VStack(spacing: 4) {
                    mediumText("\(store.averagePace)")
                    smallText("평균 페이스")
                }
                Spacer()
                VStack(spacing: 4) {
                    mediumText("\(store.runningTime.formatToTime)")
                    smallText("시간")
                }
                Spacer()
                VStack(spacing: 4) {
                    mediumText("\(store.kcal)")
                    smallText("칼로리")
                }
                Spacer()
            }
        }
    }
    
    private func smallText(_ string: String) -> some View {
        Text(string)
            .font(Fonts.pretendardRegular(size: 14))
            .foregroundStyle(.gray200)
    }
    
    private func mediumText(_ string: String) -> some View {
        Text(string)
            .font(Fonts.pretendardBold(size: 26))
            .foregroundStyle(.white)
    }
    
    private func runningCourseView(_ routes: [RURoute]) -> some View {
        if true {
            return RunningCourseMapView(routes: routes)
        } else {
            Canvas { context, size in
                // 모든 좌표를 정규화하기 위한 계산
                let coordinates = routes.flatMap { [$0.start, $0.end] }
                let latitudes = coordinates.map { $0.latitude }
                let longitudes = coordinates.map { $0.longitude }
                
                let minLat = latitudes.min()!
                let maxLat = latitudes.max()!
                let minLong = longitudes.min()!
                let maxLong = longitudes.max()!
                
                // 각 경로를 그리기
                for route in routes {
                    let startX = normalize(route.start.longitude, min: minLong, max: maxLong) * size.width
                    let startY = normalize(route.start.latitude, min: minLat, max: maxLat) * size.height
                    let endX = normalize(route.end.longitude, min: minLong, max: maxLong) * size.width
                    let endY = normalize(route.end.latitude, min: minLat, max: maxLat) * size.height
                    
                    let path = Path { p in
                        p.move(to: CGPoint(x: startX, y: startY))
                        p.addLine(to: CGPoint(x: endX, y: endY))
                    }
                    
                    context.stroke(path, with: .color(.blue), lineWidth: 3)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 500)
        }
    }
    
    private func normalize(_ value: Double, min: Double, max: Double) -> Double {
        return (value - min) / (max - min)
    }
}

struct RunningCourseMapView: View {
    let routes: [RURoute]
    @State private var region: MapCameraPosition
    
    init(routes: [RURoute]) {
        self.routes = routes
        
        // 모든 좌표를 포함하는 region 계산
        let coordinates = routes.flatMap { [$0.start, $0.end] }
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        let center = CLLocationCoordinate2D(
            latitude: (latitudes.max()! + latitudes.min()!) / 2,
            longitude: (longitudes.max()! + longitudes.min()!) / 2
        )
        
        // 모든 포인트를 포함하도록 여유있게 region 설정
        let span = MKCoordinateSpan(
            latitudeDelta: (latitudes.max()! - latitudes.min()!) * 1.5,
            longitudeDelta: (longitudes.max()! - longitudes.min()!) * 1.5
        )
        
        self._region = State(initialValue: .region(MKCoordinateRegion(center: center, span: span)))
    }
    
    var body: some View {
        Map(position: $region) {
            ForEach(0..<routes.count, id: \.self) { index in
                let route = routes[index]
                let coordinates = [
                    CLLocationCoordinate2D(latitude: route.start.latitude, longitude: route.start.longitude),
                    CLLocationCoordinate2D(latitude: route.end.latitude, longitude: route.end.longitude)
                ]
                MapPolyline(MKPolyline(coordinates: coordinates, count: 2))
                    .stroke(.blue, lineWidth: 4)
            }
        }
        .frame(height: 300)
    }
}
