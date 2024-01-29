//
//  ViewController.swift
//  Map
//
//  Created by emil kurbanov on 29.03.2023.
//тест Fork

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {

   private let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
   private let centreButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Центр", for: .normal)
       button.setTitleColor(.white, for: .normal)
       button.backgroundColor = .gray
       button.layer.cornerRadius = 5
       button.addTarget(self, action: #selector(centreMap), for: .touchUpInside)
        return button
    }()
   private let actionButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Приблизить", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(actionMap), for: .touchUpInside)
        return button
    }()
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [centreButton,actionButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 15
        return stack
    }()
    
    var pin: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(stack)
        settingMaps()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    func setLayout() {
        mapView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(600)
            $0.width.equalToSuperview()
        }
        stack.snp.makeConstraints{
            $0.top.equalTo(mapView.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(15)
            centreButton.snp.makeConstraints {
                $0.width.equalTo(110)
            }
            actionButton.snp.makeConstraints {
                $0.width.equalTo(110)
            }
        }
    }
    
    func settingMaps() {
        let initialLocation = CLLocation(latitude: 55.7522, longitude: 37.6156)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let mapTileOverlay = MKTileOverlay(urlTemplate: "http://tile.openstreetmap.org/{z}/{x}/{y}.png")
        mapTileOverlay.canReplaceMapContent = true
        mapView.addOverlay(mapTileOverlay)
        
        //обработчик нажатий и скрытий по карте
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if let existingPin = pin {
            mapView.removeAnnotation(existingPin)
            pin = nil
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            pin = annotation
        }
    }
    
    @objc func centreMap() {
        let startLocation = CLLocation(latitude: 55.7522, longitude: 37.6156)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: startLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    /* Немного не понял что делать со второй кнопкой?  В задании было написано: "режим", я сделал приближения к выбранной точке на карте, если она есть.
       Можно сделать любые другие действия, допустим прописать маршрут по нескольким точкам и выделять маркером, либо другие экшены...*/
    
    @objc func actionMap() {
        guard let pin = pin else { return }
        let regionRadius: CLLocationDistance = 100
        let startLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: startLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKOverlayRenderer(overlay: overlay)
    }
}
