//
//  RunAloneHomeView.swift
//  RunUs
//
//  Created by Ryeong on 8/5/24.
//

import SwiftUI
import ComposableArchitecture

struct RunAloneHomeView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<RunAloneHomeFeature> = StoreDIManager.runAloneHome
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let showLocationPermissionAlert = viewStore.binding(
                get: \.showLocationPermissionAlert,
                send: { .locationPermissionAlertChanged($0) })
            
            Text("혼자 뛰기 화면")
                .onAppear {
                    store.send(.onAppear)
                }
                .alert(Bundle.main.locationString,
                       isPresented: showLocationPermissionAlert) {
                    Button("취소", role: .cancel) {
                        
                    }
                    Button("설정", role: .destructive) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
        }
    }
}


#Preview {
    RunAloneHomeView()
}
