//
//  RunUs.swift
//  RunUs
//
//  Created by seungyooooong on 8/9/24.
//

import SwiftUI

struct RunUs: View {
    @State var isLoading: Bool = true
    
    var body: some View {
        if isLoading { SplashView(isLoading: $isLoading) }
        else         { MainView() } // 추후 네이밍 수정
    }
}

#Preview {
    RunUs()
}
