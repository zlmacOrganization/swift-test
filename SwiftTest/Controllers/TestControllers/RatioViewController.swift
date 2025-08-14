//
//  RatioViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/6/28.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import UIKit
//import MAMapKit
//import AMapSearchKit
//import AMapLocationKit

class RatioViewController: BaseViewController {

//    private lazy var locationManager = AMapLocationManager()
//    private lazy var fenceManager = AMapGeoFenceManager()
//    private let annotation = MAPointAnnotation()
//    private var regions = Array<AMapLocationCircleRegion>()
//
//    var completionBlock: AMapLocatingCompletionBlock!
//
//    private var searchApi = AMapSearchAPI()
//    private var searchResponse: AMapReGeocodeSearchResponse!
//    private var currentLocation = CLLocationCoordinate2D(latitude: 22.28196044921875, longitude: 16317111545139)
//
//    private var mapCenterCoor = CLLocationCoordinate2D(latitude: 31.224681, longitude: 121.528177)
    
//    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var tableView: UITableView!
    
//    private var datas: [AMapPOI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: -

    private func setupMapView() {
//        AMapServices.shared()?.enableHTTPS = true
//
//        mapView.delegate = self
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
//        mapView.zoomLevel = 15
////        mapView.setCenter(mapCenterCoor, animated: true)
//
//        let r = MAUserLocationRepresentation()
//        r.showsAccuracyRing = false
//        mapView.update(r)
//
//        searchApi?.delegate = self
    }
    
    private func initCompleteBlock() {
        
//        completionBlock = { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
//
//            if let error = error {
//                let error = error as NSError
//
//                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
//                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
//                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
//                    return
//                }
//                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
//                    || error.code == AMapLocationErrorCode.timeOut.rawValue
//                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
//                    || error.code == AMapLocationErrorCode.badURL.rawValue
//                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
//                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
//
//                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
//                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
//                }
//                else {
//                    //NSLog("location+regeocode:{\(location) - \(regeocode)};")
//                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
//                }
//            }
//
//            if let location = location {
//                let coor = location.coordinate
//                let request2 = AMapPOIAroundSearchRequest()
//                request2.location = AMapGeoPoint.location(withLatitude: CGFloat(coor.latitude), longitude: CGFloat(coor.longitude))
//                request2.radius = 1000
//                request2.types = "风景名胜｜交通设施服务｜公司企业｜地名地址信息"
//                self?.searchApi?.aMapPOIAroundSearch(request2)
//            }
//        }
    }
    
    //MARK: - search
    private func startAroundSearch() {
//        let request = AMapPOIAroundSearchRequest()
//        request.location = AMapGeoPoint.location(withLatitude: CGFloat(currentLocation.latitude), longitude: CGFloat(currentLocation.longitude))
//        request.types = "风景名胜｜交通设施服务｜公司企业｜地名地址信息"
//        //"建筑|写字楼|小区|楼盘|商务住宅|公共设施|道路附属设施|地名地址信息|政府机构及社会团体|住宿服务|风景名胜"
//        request.radius = 1000
//
//        searchApi?.aMapPOIAroundSearch(request)
        
//        locationManager.requestLocation(withReGeocode: true, completionBlock: completionBlock)
    }
    
    private func startReGeocodeSearch() {
//        let request = AMapReGeocodeSearchRequest()
//        request.location = AMapGeoPoint.location(withLatitude: CGFloat(currentLocation.latitude), longitude: CGFloat(currentLocation.longitude))
//
//        searchApi?.aMapReGoecodeSearch(request)
        
//        locationManager.requestLocation(withReGeocode: true, completionBlock: completionBlock)
    }
    
    private func addAnnotiation() {
        
    }

    //MARK: - manager
    private func setupLocationManager() {
//        fenceManager.delegate = self
//        fenceManager.activeAction = [AMapGeoFenceActiveAction.inside , AMapGeoFenceActiveAction.outside , AMapGeoFenceActiveAction.stayed ]//进入，离开，停留都要进行通知
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.allowsBackgroundLocationUpdates = false
//        locationManager.locationTimeout = 10
//        locationManager.reGeocodeTimeout = 5
    }
    
    //添加地理围栏对应的Overlay，方便查看。地图上显示圆
//    func showCircle(inMap coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> MACircle {
//        let circleOverlay = MACircle(center: coordinate, radius: radius)
//        mapView.add(circleOverlay)
//        return circleOverlay!
//    }
    
    //清除上一次按钮点击创建的围栏
    func doClear() {
//        mapView.removeOverlays(mapView.overlays)
//        fenceManager.removeAllGeoFenceRegions()
    }
    
    deinit {
//        mapView.delegate = nil
    }
}

extension RatioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zl_dequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        
//        let item = datas[indexPath.row]
//        cell.textLabel?.text = item.address ?? item.name ?? "no data"
        
        return cell
    }
}

//MARK: - AMapLocationManagerDelegate
//extension RatioViewController: AMapLocationManagerDelegate {
//    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
//        locationManager.requestAlwaysAuthorization()
//    }
//
//    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
//        annotation.coordinate = location.coordinate
//        if let regeocode = reGeocode {
//            annotation.title = regeocode.formattedAddress
//            annotation.subtitle = "\(regeocode.citycode!)-\(regeocode.adcode!)-\(location.horizontalAccuracy)m"
//        } else {
//            annotation.title = String(format: "lat:%.6f;lon:%.6f;", arguments: [location.coordinate.latitude, location.coordinate.longitude])
//            annotation.subtitle = "accuracy:\(location.horizontalAccuracy)m"
//        }
//
//        mapView.centerCoordinate = location.coordinate
//        mapView.setZoomLevel(14, animated: true)
//    }
//}
//
////MARK: - AMapGeoFenceManagerDelegate
//extension RatioViewController: AMapGeoFenceManagerDelegate {
//
//}
//
////MARK: - AMapSearchDelegate
//extension RatioViewController: AMapSearchDelegate {
//    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
//        debugPrint("search failed: \(error.debugDescription)")
//    }
//
//    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
//        if let pois = response.regeocode.pois {
//            datas = pois
//        }
//        tableView.reloadData()
//    }
//
//    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
//        if let pois = response.pois {
//            datas = pois
//        }
//        tableView.reloadData()
//    }
//}
//
////MARK: - MAMapViewDelegate
//extension RatioViewController: MAMapViewDelegate {
//
//    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
//        currentLocation = mapView.userLocation.location.coordinate
//        startReGeocodeSearch()
////        startAroundSearch()
//    }
//
//    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
//        debugPrint("didFailToLocateUser: \(error.debugDescription)")
//    }
//
//    func mapViewDidFailLoadingMap(_ mapView: MAMapView!, withError error: Error!) {
//        debugPrint("DidFailLoadingMap: \(error.debugDescription)")
//    }
//
//    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
////        if let annotation = view.annotation, annotation is MAUserLocation {
////            mapView.userLocation.title = searchResponse.regeocode.addressComponent.city
////            mapView.userLocation.subtitle = searchResponse.regeocode.formattedAddress
////        }
//    }
//
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        if annotation is MAPointAnnotation {
//            let identifier = "pointAnnotation"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MAPinAnnotationView
//
//            if annotationView == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = false
//                annotationView?.animatesDrop = false
//                annotationView?.image = UIImage(named: "icon_location")
//
//                return annotationView
//            }
//        }
//
//        return nil
//    }
//}
