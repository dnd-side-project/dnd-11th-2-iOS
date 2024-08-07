//
//  LoginView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

struct LoginView: View {
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var userEnvironment: UserEnvironment
    var store: StoreOf<LoginStore> = Store(
        initialState: LoginStore.State(userEnvironment: UserEnvironment()),
        reducer: { LoginStore() }
    )
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Run Earth With Runus!")
                        .font(Fonts.pretendardMedium(size: 24))
                    Text("런어스랑 지구한바퀴 뛰어보기")
                        .font(Fonts.pretendardExtraBold(size: 24))
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.top, 160 + 8)
            Spacer()
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    SignInWithAppleButton(
                        onRequest: { request in
                            viewStore.send(.appleLoginRequest(request))
                        },
                        onCompletion: { result in
                            viewStore.send(.appleLoginResult(result))
                        }
                    )
                    Label(  // 추후 컴포넌트화하기
                        title: {
                            Text("Apple ID로 시작하기")
                                .font(Fonts.pretendardVariable(size: 16))
                        },
                        icon: { Image(systemName: "apple.logo") }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Colors.black)
                    .background(Colors.white)
                    .allowsHitTesting(false)
                }
                .cornerRadius(24)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 67 + 8)
                .onAppear {
                    viewStore.send(.setUserEnvironment(userEnvironment))
                }
            }
        }
        .padding(Paddings.outsideHorizontalPadding)
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
    .environmentObject(UserEnvironment())
}
