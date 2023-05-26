//
//  MapKit.swift
//  MAPINEDIII
//
//  Created by Nikolas Arthur Herawan on 22/05/23.
//
import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                latitude: -6.25021,
                longitude: 106.62516),
                span: MKCoordinateSpan(latitudeDelta: 0.03,
                longitudeDelta: 0.03)
                )
    
    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D

struct ContentView: View {
    
    @State private var region: MKCoordinateRegion =
    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -6.25021, longitude: 106.62516), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    private var pointsOfInterest = [
        AnnotatedItem(name: "Chin-Ma-Ya", coordinate: .init(latitude: -6.25021, longitude: 106.62516)),
        AnnotatedItem(name: "The Bunker Cafe", coordinate: .init(latitude: -6.25200, longitude: 106.62592)),
        AnnotatedItem(name: "Warteg Bu Le", coordinate:
                .init (latitude: -6.25089, longitude: 106.62880))
        ]
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: pointsOfInterest) {
            item in
            MapAnnotation(coordinate: item.coordinate) {
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(Color.blue, lineWidth: 4.0)
                    .frame(width: 30, height: 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
