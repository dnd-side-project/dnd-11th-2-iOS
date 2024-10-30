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
    
    var body: some MapContent {
        ForEach(segments.indices, id: \.self) { index in
            let segment = segments[index]
            let coordinates = [segment.start, segment.end]
            MapPolyline(MKPolyline(coordinates: coordinates, count: 2))
                .stroke(.mainGreen, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
        }
    }
}

struct RouteSegment: Hashable {
    let start: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
    
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
