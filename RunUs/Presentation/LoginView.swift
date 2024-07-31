//
//  LoginView.swift
//  RunUs
//
//  Created by seungyooooong on 7/22/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Run Earth With Runus!")
                            .font(Fonts.pretendardMedium24)
                        Text("런어스랑 지구한바퀴 뛰어보기")
                            .font(Fonts.pretendardExtraBold24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    Spacer()
                }
                .foregroundStyle(.white)
                .padding(.top, 160)
                Spacer()
                Button {
                    
                } label: {
                    Label(  // 추후 컴포넌트화하기
                        title: {
                            Text("Apple ID로 시작하기")
                                .font(Fonts.pretendardVariable16)
                        },
                        icon: { Image(systemName: "apple.logo") }
                    )
                }
                .foregroundColor(.black)
                .background {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 320, height: 48)
                        .cornerRadius(24)
                }
                .padding(.bottom, 75)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    LoginView()
}
