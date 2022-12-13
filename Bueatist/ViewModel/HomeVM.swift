//
//  HomeVM.swift
//  Bueatist
//
//  Created by Hertz on 12/14/22.
//

import Foundation
import SwiftUI
import MapKit

enum MapDetail {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.469358, longitude: 126.898333)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    static let middleSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    static let largeSpan = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
}

final class HomeVM: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    /// 초기 지역상태
    @Published var region = MKCoordinateRegion(center: MapDetail.startingLocation,
                                               span: MapDetail.defaultSpan)
    
    /// 초기 플레이스 마커
    @Published var places = [
        Place(name: "레더", latitude: 37.6433, longitude: 127.0102),
        Place(name: "Position 2", latitude: 37.6188, longitude: 127.0293),
    ]
    
    var locationManager: CLLocationManager?
    
    /// 위치공유 시스템이 활성화 되어 있다면
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("위치추적기능을 켜십시오")
        }
        
    }
    
    /// 위치 정보
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("your location is restricted likely due to parental controls")
        case .denied:
            print("you have denied this app location permission Go into setting to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MapDetail.defaultSpan)
        @unknown default:
            break
        }
    }
    
    /// 위치 업데이트
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

