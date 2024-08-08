//
//  HomeView.swift
//  RunUs
//
//  Created by seungyooooong on 7/23/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        //FIXME: 홈화면 디자인 나오면 수정
        NavigationView{
            NavigationLink {
                RunAloneHomeView()
                    .navigationBarBackButtonHidden()
            } label: {
                Text("혼자뛰기")
            }
        }
    }
}

#Preview {
    HomeView()
}
