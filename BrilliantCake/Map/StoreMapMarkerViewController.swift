//
//  SimplePOI.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/21/24.
//

import UIKit
import KakaoMapsSDK

final class StoreMapMarkerViewController: MapViewController {
    
    var coord = [0.0, 0.0]
    var storeInfo:(String, String) = ("", "")
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: coord[0], latitude: coord[1])
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        createLabelLayer()
        createPoiStyle()
        createPois()
    }

    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let resizedImage = resizeImage(image: UIImage(named: ImageName.mapPointer)!, targetSize: CGSize(width: 45, height: 45))
        let iconStyle = PoiIconStyle(symbol: resizedImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)
    }
    
    // POI를 생성한다.
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1")
        poiOption.rank = 0
        poiOption.clickable = true
        let poi1 = layer?.addPoi(option: poiOption, at: MapPoint(longitude: coord[0], latitude: coord[1]), callback: {(_ poi: (Poi?)) -> Void in
            print("")
        })
        let _ = poi1?.addPoiTappedEventHandler(target: self, handler: StoreMapMarkerViewController.poiTappedHandler)
        poi1?.show()
    }
    
    //마커 탭 이벤트
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        //param.poiItem.hide()
        showPointInfo(title: storeInfo.0, subtitle: storeInfo.1)
    }
    
 
    
    func showPointInfo(title: String, subtitle: String) {
        let infoView = StoreMapInfoView(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 130), title: title, address: subtitle)
        self.view.addSubview(infoView)
    }
}
