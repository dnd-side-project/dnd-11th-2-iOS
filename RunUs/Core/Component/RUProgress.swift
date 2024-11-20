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
    var startName: String? = nil
    var endName: String? = nil
    var hasPin: Bool = true
    let gradient = LinearGradient(colors: [.mainBlue, .mainGreen], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        if type == .bar {
            RUProgressBar
        } else {
            RUProgressCircle
        }
    }
    
    private var RUProgressBar: some View {
        VStack(spacing: 6) {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: -4) {
                        Spacer().frame(width: geometry.size.width * CGFloat(percent))
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
                            .frame(width: geometry.size.width * CGFloat(percent), height: 7)
                            .foregroundStyle(gradient)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 27)
            if let startName = startName, let endName = endName {
                HStack {
                    Text(startName)
                    Spacer()
                    Text(endName)
                }
                .font(Fonts.pretendardRegular(size: 12))
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
    RUProgress(percent: 0.72).padding().background(Color.background)
}
