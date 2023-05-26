//
//  SearchView.swift
//  MAPINEDIII
//
//  Created by Nikolas Arthur Herawan on 22/05/23.
//

import SwiftUI
import MapKit

struct SearchView: View {
struct MyDetent: CustomPresentationDetent {
        // 1
        static func height(in context: Context) -> CGFloat? {
            // 2
            return max(50, context.maxDetentValue * 0.2)
        }
    }
    @StateObject var locationManager: LocationManager = .init()
    // MARK: Navigation Tag to Push View to MapView
    @State var navigationTag: String?
    @State var presentSheet = false
    
    var body: some View {
        ZStack{
            // MARK: Sample Corrdinate Region
            let region = MKCoordinateRegion (center:
                                                CLLocationCoordinate2D(latitude: -6.28235, longitude: 106.71334), latitudinalMeters: 10000, longitudinalMeters: 10000)
            Map (coordinateRegion: .constant(region))
                .ignoresSafeArea()
            
            // MARK: Building Sheet UI
                .sheet(isPresented: .constant(true)) {
                    VStack{
                        
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Find Locations Here", text: $locationManager.searchText)
                        }
                        .padding(.vertical,12)
                        .padding(.horizontal)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(.gray)
                        }
                        .padding(.vertical,10)
                        
                        if let places = locationManager.fetchedPlaces,!places.isEmpty{
                            List{
                                ForEach(places,id: \.self){place in
                                    Button {
                                        if let coordinate = place.location?.coordinate{
                                            locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                            locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                            locationManager.addDraggablePin(coordinate: coordinate)
                                            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                        }
                                        
                                        // MARK: Navigating To MapView
                                        navigationTag = "MAPVIEW"
                                    } label: {
                                        HStack(spacing: 15){
                                            Image(systemName: "mappin.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.gray)
                                            
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(place.name ?? "")
                                                    .font(.title3.bold())
                                                    .foregroundColor(.primary)
                                                
                                                Text(place.locality ?? "")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            .listStyle(.plain)
                        }
                        else{
                            // MARK: Live Location Button
                            Button {
                                // MARK: Setting Map Region
                                if let coordinate = locationManager.userLocation?.coordinate{
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    locationManager.addDraggablePin(coordinate: coordinate)
                                    locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                    
                                    // MARK: Navigating To MapView
                                    navigationTag = "MAPVIEW"
                                }
                            } label: {
                                Label {
                                    Text("Use Current Location")
                                        .font(.callout)
                                } icon: {
                                    Image(systemName: "location.north.circle.fill")
                                }
                                .foregroundColor(.blue)
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10.0)
                                .strokeBorder(Color.gray)
                                .frame(width: 360, height: 100)
                                .position(x: 180, y: 60)
                            HStack{
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.orange)
                                    .position(x: 60, y: 58)
                                    .font(.system(size: 60.0))
                                    .frame(maxWidth: .infinity,alignment: .topLeading)
                                VStack{
                                    Text("Chin-Ma-Ya")
                                        .font(.callout)
                                        .frame(maxWidth: .infinity,alignment: .topLeading)
                                    Text("120ft away, near Jalan Boulevard Raya")
                                        .font(.callout)
                                        .fontWeight(.thin)
                                        .frame(maxWidth: .infinity,alignment: .topLeading)
                                }
                                .position(x: 50, y: 55)
                            }
                        }
                    }
                   
                    .padding()
                    .frame(maxHeight: .infinity,alignment: .top)
                    .presentationDetents([.medium, .large])
                    .presentationContentInteraction(.scrolls)
                }
                
            
            .background{
                NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                    MapViewSelection()
                        .environmentObject(locationManager)
                        .navigationBarHidden(true)
                } label: {}
                    .labelsHidden()
                
                
            }
        }
    }
    
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    // MARK: MapView Live Selection
    struct MapViewSelection: View{
        @EnvironmentObject var locationManager: LocationManager
        @Environment(\.dismiss) var dismiss
        var body: some View{
            ZStack{
                MapViewHelper()
                    .environmentObject(locationManager)
                    .ignoresSafeArea()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                
                // MARK: Displaying Data
                if let place = locationManager.pickedPlaceMark{
                    VStack(spacing: 15){
                        Text("Confirm Location")
                            .font(.title2.bold())
                        
                        HStack(spacing: 15){
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                
                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical,10)
                        
                        Button {
                            
                        } label: {
                            Text("Confirm Location")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical,12)
                                .background{
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.blue)
                                }
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "arrow.right")
                                        .font(.title3.bold())
                                        .padding(.trailing)
                                }
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .ignoresSafeArea()
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .onDisappear {
                locationManager.pickedLocation = nil
                locationManager.pickedPlaceMark = nil
                locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
                
            }
        }
    }
    
    // MARK: UIKit MapView
    struct MapViewHelper: UIViewRepresentable{
        @EnvironmentObject var locationManager: LocationManager
        func makeUIView(context: Context) -> MKMapView {
            return locationManager.mapView
        }
        func updateUIView(_ uiView: MKMapView, context: Context) {}
    }
}
