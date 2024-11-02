//
//  LoadingView.swift
//  RunUs
//
//  Created by seungyooooong on 11/2/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth:. infinity, maxHeight: .infinity)
            .background(Color.background.opacity(0.2))
    }
}

#Preview {
    LoadingView()
}
