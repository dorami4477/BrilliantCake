//
//  MapViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/17/24.
//

import UIKit
import KakaoMapsSDK

class MapViewController: UIViewController, MapControllerDelegate {
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = KMViewContainer(frame: self.view.frame)
        self.view.addSubview(containerView)
        mapContainer = containerView
        
        // KMController 생성.
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        mapController?.prepareEngine() // 엔진 준비
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _auth {
            if mapController?.isEngineActive == false {
                mapController?.activateEngine()
            }
        }
    }
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
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
        addViews()
    }
    
    // MapControllerDelegate. 인증에 실패했을 경우 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("\(desc)")

        // 추가 실패 처리 작업
        mapController?.prepareEngine() // 인증 재시도
    }
}
