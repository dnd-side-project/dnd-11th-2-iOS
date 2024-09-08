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
    let store: StoreOf<LoginStore> = Store(
        initialState: LoginStore.State(),
        reducer: { LoginStore() }
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    Text("Run ")
                        .foregroundStyle(.white)
                    Text("Earth ")
                    Text("With ")
                        .foregroundStyle(.white)
                    Text("Runus!")
                }
                .font(Fonts.pretendardSemiBold(size: 24))
                Text("런어스랑 지구한바퀴 뛰어보기")
                    .font(Fonts.pretendardExtraBold(size: 24))
            }
            .foregroundStyle(.mainGreen)
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            Image(.login)
                .resizable()
                .scaledToFit()
            Spacer()
            ZStack {
                SignInWithAppleButton(
                    onRequest: { request in
                        store.send(.appleLoginRequest(request))
                    },
                    onCompletion: { result in
                        store.send(.appleLoginResult(result))
                    }
                )
                Label(  // TODO: 컴포넌트화
                    title: {
                        Text("Apple ID로 시작하기")
                            .font(Fonts.pretendardVariable(size: 16))
                    },
                    icon: { Image(systemName: "apple.logo") }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.black)
                .background(.white)
                .allowsHitTesting(false)
            }
            .cornerRadius(24)
            .frame(height: 48)
            .padding(.horizontal, Paddings.outsideHorizontalPadding)
            Spacer()
        }
        .background(Color.background)
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
        .background(Color.background)
}
