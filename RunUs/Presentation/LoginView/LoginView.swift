//
//  LoginView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginStore>
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Run Earth With Runus!")
                        .font(.custom(Fonts.pretendardMedium, size: 24))
                    Text("런어스랑 지구한바퀴 뛰어보기")
                        .font(.custom(Fonts.pretendardExtraBold, size: 24))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.top, 160)
            Spacer()
            WithViewStore(store, observe: { $0 }) { viewStore in
                Button {
                    viewStore.send(.doAppleLogin)
                } label: {
                    Label(  // 추후 컴포넌트화하기
                        title: {
                            Text("Apple ID로 시작하기")
                                .font(.custom(Fonts.pretendardVariable, size: 16))
                        },
                        icon: { Image(systemName: "apple.logo") }
                    )
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .background {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(24)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(height: 48 + 16)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 67)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginStore.State(userEnvironment: UserEnvironment()),
            reducer: { LoginStore() }
        )
    )
    .background(Colors.background)
}
