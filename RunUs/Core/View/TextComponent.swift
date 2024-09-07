//
//  TextComponent.swift
//  RunUs
//
//  Created by Ryeong on 9/7/24.
//

import SwiftUI

struct SmallText: View {
    @State var string: String
    
    init(_ string: String) {
        self.string = string
    }
    
    var body: some View {
        Text(string)
            .font(Fonts.pretendardRegular(size: 12))
            .foregroundStyle(.gray200)
    }
}

struct MediumText: View {
    @State var string: String
    
    init(_ string: String) {
        self.string = string
    }
    
    var body: some View {
        Text(string)
            .font(Fonts.pretendardBold(size: 26))
            .foregroundStyle(.white)
    }
}
