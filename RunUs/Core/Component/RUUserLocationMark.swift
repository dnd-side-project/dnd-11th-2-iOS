//
//  RUUserLocationMark.swift
//  RunUs
//
//  Created by seungyooooong on 11/13/24.
//

import SwiftUI

struct RUUserLocationMark: View {
    var body: some View {
        Image(.userLocationMark)
            .background {
                Circle()
                    .fill(.mainGreen.opacity(0.6))
                    .blur(radius: 7.8)
            }
    }
}

#Preview {
    RUUserLocationMark()
}
