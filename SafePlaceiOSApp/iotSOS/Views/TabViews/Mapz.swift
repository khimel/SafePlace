//
//  Map.swift
//  iotSOS
//
//  Created by Mohammad Khimel on 07/06/2021.
//

import SwiftUI
import MapKit 
struct Mapz: View {
    @EnvironmentObject var manager : LocationManager
    @EnvironmentObject var usernameInfo: LoggedUsername
    @State var alert = false
    @State var shareLocation = true
    @EnvironmentObject var modelData: ModelData
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.03825893, longitude: 34.74960976), latitudinalMeters: 20000, longitudinalMeters: 20000)
    var body: some View {
        VStack{
            Button(action:{
                modelData.fillAnnotatedItems(){ (items) in
                    DispatchQueue.main.async {
                        modelData.annotations = items
                    }
                }
            }){
                Text("Refresh")
            }
            Map(coordinateRegion: $region,showsUserLocation: true, annotationItems: modelData.annotations) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    VStack{
                        Circle().stroke(Color.red, lineWidth: 5.0)
                        Text(item.name)
                        Text(item.phone)
                    }
                }
            }.onAppear(){
                print(manager.location!.coordinate)
            }
        }
        
    }
}

struct Mapz_Previews: PreviewProvider {
    static var previews: some View {
        Mapz()
    }
}



struct MapView : UIViewRepresentable {

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true;
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    
    class Coordinator : NSObject,CLLocationManagerDelegate, MKMapViewDelegate{
        var control : MapView
        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
            if let annotationView = views.first{
                if let annotation = annotationView.annotation {
                    if annotation is MKUserLocation{
                        
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        mapView.setRegion(region, animated: true)
                        
                    }
                }
            }
        }
    }
}




