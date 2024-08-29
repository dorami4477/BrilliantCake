//
//  TestMapViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/21/24.
//

import UIKit
import CoreLocation
import KakaoMapsSDK
import RxSwift

class MapViewController: BaseViewController, MapControllerDelegate {
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    
    let viewModel = MapViewModel()
    let disposeBag = DisposeBag()
    let locationManager = CLLocationManager()
    var didRequestLocationPermission = false
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        print("deinit")
    }
    
    private let currentLocationButton = {
       let button = UIButton()
        button.setImage(UIImage(named: ImageName.currentLocation), for: .normal)
        button.tintColor = .main
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKaKaoMap()
        bind()
    }

    private func bind() {
        let input = MapViewModel.Input(currentLocationTap: currentLocationButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.currentLocationTap
            .bind(with: self) { owner, _ in
                owner.didRequestLocationPermission = true
                owner.checkCurrentLocationAuthorization()
            }
            .disposed(by: disposeBag)
    }
    
    func configureKaKaoMap() {
        let containerView = KMViewContainer(frame: self.view.frame)
        self.view.addSubview(containerView)
        self.view.addSubview(currentLocationButton)
        mapContainer = containerView
        
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        locationManager.delegate = self

        currentLocationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.size.equalTo(40)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine() //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    // 인증 성공시 delegate 호출.
    func authenticationSucceeded() {

        if _auth == false {
            _auth = true
        }
        
        if _appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }

    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(message: "지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            showToast(message: "지도 종료(API인증 키 오류)")
            break;
        case 403:
            showToast(message: "지도 종료(API인증 권한 오류)")
            break;
        case 429:
            showToast(message: "지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            showToast(message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {

        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 4)

        mapController?.addView(mapviewInfo)
    }
    

    func viewInit(viewName: String) {
        print("OK")
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds    //뷰 add 도중에 resize 이벤트가 발생한 경우 이벤트를 받지 못했을 수 있음. 원하는 뷰 사이즈로 재조정.
        viewInit(viewName: viewName)
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
       
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        _observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        _observerAdded = false
    }

    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }

    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            if let kakaoMapView = mapController?.getView("mapview") as? KakaoMap {
                let cameraUpdate = CameraUpdate.make(target: MapPoint(longitude: coordinate.longitude, latitude: coordinate.latitude), zoomLevel: 15, rotation: 0.0, tilt: 0.0, mapView: kakaoMapView)
                
                kakaoMapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: true, consecutive: false, durationInMillis: 2000))

            }

        }
        locationManager.stopUpdatingLocation() // 위치 업데이트 중지
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
    private func checkDeviceLocationAuthorization(){
        //아이폰 위치 서비스 켜졌는지 확인
        if didRequestLocationPermission {
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled(){
                    self.checkCurrentLocationAuthorization()
                }else{
                    print("해당 아이폰의 위치 서비스가 꺼져있습니다.")
                }
            }
        }
        didRequestLocationPermission = false
    }
    
    private func checkCurrentLocationAuthorization() {
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            print(status)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 권한 설정 메시지 띄우기
        case .denied:
            print(status)
            showLocationAlert() // iOS 설정 창으로 이동하라는 얼럿을 띄워주기
        case .authorizedWhenInUse:
            print(status)
            locationManager.startUpdatingLocation() // 현재 위치 업데이트 시작
        case .restricted:
            print("Restricted location access")
        default:
            print(status)
        }
        
    }
    
    private func showLocationAlert() {
        let alertController = UIAlertController(title: "위치 권한 필요", message: "현재 위치를 확인하려면 위치 권한이 필요합니다.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
