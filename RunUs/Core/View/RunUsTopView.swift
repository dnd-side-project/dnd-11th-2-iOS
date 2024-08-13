//
//  RunUsTopView.swift
//  RunUs
//
//  Created by seungyooooong on 8/9/24.
//

import SwiftUI

struct RunUsTopView: View {
    @State var isLoading: Bool = true
    
    var body: some View {
        if isLoading { SplashView(isLoading: $isLoading) }
        else { MainView() }
    }
}

#Preview {
    RunUsTopView()
}
