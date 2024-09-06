//
//  RunningCircleButton.swift
//  RunUs
//
//  Created by Ryeong on 8/16/24.
//

import SwiftUI

struct CircleButtonView: View {
    private let size: CGFloat
    private let imageResource: ImageResource
    
    init(size: CGFloat = 60,
         _ image: ImageResource) {
        self.size = size
        self.imageResource = image
    }
    
    var body: some View {
        Circle()
            .frame(width: size)
            .foregroundStyle(.mainDeepDark)
            .overlay {
                Image(imageResource)
            }
    }
}

#Preview {
    CircleButtonView(size: 60, .buttonResume)
}
