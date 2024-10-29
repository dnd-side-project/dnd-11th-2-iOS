//
//  RouteSegment.swift
//  RunUs
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation
import SwiftUI
import MapKit

struct HeatMapPolylineContent: MapContent {
    let segments: [RouteSegment]
    
    func colorForPassCount(_ count: Int) -> Color {
        switch count {
        case 1: return .mainGreen.opacity(0.6)
        case 2: return .mainGreen.opacity(0.8)
        default: return .mainGreen
        }
    }
    
    var body: some MapContent {
        ForEach(segments.indices, id: \.self) { index in
            let segment = segments[index]
            let coordinates = [segment.start, segment.end]
            MapPolyline(MKPolyline(coordinates: coordinates, count: 2))
                .stroke(colorForPassCount(segment.passCount), lineWidth: 6)
        }
    }
}

struct RouteSegment: Hashable {
    let start: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
    var passCount: Int = 1
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(start.latitude)
        hasher.combine(start.longitude)
        hasher.combine(end.latitude)
        hasher.combine(end.longitude)
    }
    
    static func ==(lhs: RouteSegment, rhs: RouteSegment) -> Bool {
        let isSameDirection = lhs.start.latitude == rhs.start.latitude &&
                            lhs.start.longitude == rhs.start.longitude &&
                            lhs.end.latitude == rhs.end.latitude &&
                            lhs.end.longitude == rhs.end.longitude
        
        let isReverseDirection = lhs.start.latitude == rhs.end.latitude &&
                                lhs.start.longitude == rhs.end.longitude &&
                                lhs.end.latitude == rhs.start.latitude &&
                                lhs.end.longitude == rhs.start.longitude
        
        return isSameDirection || isReverseDirection
    }
}
