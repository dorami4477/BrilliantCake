//
//  MapViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit
import CoreLocation
import KakaoMapsSDK
import SnapKit
import RxSwift
import RxCocoa

final class MapViewController: BaseViewController, MapControllerDelegate {
    
    private let currentLocationButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "BC_16"), for: .normal)
        button.tintColor = .main
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false

    
    let viewModel = MapViewModel()
    let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKaKaoMap()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentLocationButton.frame.size = CGSize(width: 30, height: 30)
        
        // 레이아웃을 다시 설정
        currentLocationButton.setNeedsLayout()
        currentLocationButton.layoutIfNeeded()
    }
    
    private func bind() {
        let input = MapViewModel.Input(currentLocationTap: currentLocationButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.currentLocationTap
            .bind(with: self) { owner, _ in
                owner.checkCurrentLocationAuthorization()
            }
            .disposed(by: disposeBag)
    }
    
    func configureKaKaoMap() {
        let containerView = KMViewContainer(frame: self.view.frame)
        self.view.addSubview(containerView)
        self.view.addSubview(currentLocationButton)
        mapContainer = containerView
        
        // KMController 생성.
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        mapController?.prepareEngine() // 엔진 준비
        

        currentLocationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.size.equalTo(30)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _auth {
            if mapController?.isEngineActive == false {
                mapController?.activateEngine()
            }
        }
    }
    
    func addViews(coord: CLLocationCoordinate2D) {
        let defaultPosition: MapPoint = MapPoint(longitude: coord.longitude, latitude: coord.latitude)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    // MapControllerDelegate. 인증에 성공했을 경우 호출.
    func authenticationSucceeded() {
        print("성공")
        _auth = true
        // 인증 성공 후 엔진을 활성화하고 지도를 추가합니다.
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
        addViews(coord: CLLocationCoordinate2D(latitude: 37.566691, longitude: 126.978365))
    }
    
    // MapControllerDelegate. 인증에 실패했을 경우 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("\(desc)")

        // 추가 실패 처리 작업
        mapController?.prepareEngine() // 인증 재시도
    }
    
    func addViews() {
    }
    
   
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate{
            //callRequest(location: coordinate)
            print(coordinate)
            addViews(coord: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
    private func checkDeviceLocationAuthorization(){
        //아이폰 위치 서비스 켜졌는지 확인
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.checkCurrentLocationAuthorization()
            }else{
                print("해당 아이폰의 위치 서비스가 꺼져있습니다.")
            }
        }
    }
    
    private func checkCurrentLocationAuthorization(){
        var status:CLAuthorizationStatus
        if #available(iOS 14.0, *){
            status = locationManager.authorizationStatus
        }else{
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            print(status)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //권한 설정 메시지 띄우기
        case .denied:
            print(status)
            print("iOS 설정 창으로 이동하라는 얼럿을 띄워주기")
        case .authorizedWhenInUse:
            //info plist에서 설정해야함
            print(status)
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
}
