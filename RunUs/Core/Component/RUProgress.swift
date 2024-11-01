//
//  RUProgress.swift
//  RunUs
//
//  Created by seungyooooong on 10/22/24.
//

import SwiftUI

struct RUProgress: View {
    let type: ProgressTypes = .bar
    let percent: Double
    let gradient = LinearGradient(colors: [.mainBlue, .mainGreen], startPoint: .leading, endPoint: .trailing)
    let hasPin: Bool = true
    
    var body: some View {
        if type == .bar {
            RUProgressBar
        } else {
            RUProgressCircle
        }
    }
    
    private var RUProgressBar: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: -4) {
                    Spacer().frame(width: geometry.size.width * CGFloat(percent * 0.01))
                    Image(.pin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 17)
                }
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: geometry.size.width, height: 5)
                        .foregroundStyle(.gray100)
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: geometry.size.width * CGFloat(percent * 0.01), height: 7)
                        .foregroundStyle(gradient)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var RUProgressCircle: some View {
        Text("circle")
    }
}

enum ProgressTypes {
    case bar
    case circle
}

#Preview {
    RUProgress(percent: 72.8).padding().background(Color.background)
}
