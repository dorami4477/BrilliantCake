//
//  SimplePOI.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/21/24.
//

import UIKit
import KakaoMapsSDK


class StoreMapMarkerViewController: MapViewController {
    
    var coord = [0.0, 0.0]
    var storeInfo:(String, String) = ("", "")
    
    override func addViews() {
        print(coord)
        let defaultPosition: MapPoint = MapPoint(longitude: coord[0], latitude: coord[1])
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
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
        // 심볼을 지정.
        // 심볼의 anchor point(심볼이 배치될때의 위치 기준점)를 지정. 심볼의 좌상단을 기준으로 한 % 값.
        let resizedImage = resizeImage(image: UIImage(named: ImageName.mapPointer)!, targetSize: CGSize(width: 45, height: 45))
        let iconStyle = PoiIconStyle(symbol: resizedImage, anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)  // 이 스타일이 적용되기 시작할 레벨.
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)
    }
    
    // POI를 생성한다.
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")   // 생성한 POI를 추가할 레이어를 가져온다.
        let poiOption = PoiOptions(styleID: "customStyle1") // 생성할 POI의 Option을 지정하기 위한 자료를 담는 클래스를 생성. 사용할 스타일의 ID를 지정한다.
        poiOption.rank = 0
        poiOption.clickable = true // clickable 옵션을 true로 설정한다. default는 false로 설정되어있다.
        let poi1 = layer?.addPoi(option: poiOption, at: MapPoint(longitude: coord[0], latitude: coord[1]), callback: {(_ poi: (Poi?)) -> Void in
            print("")
        })//레이어에 지정한 옵션 및 위치로 POI를 추가한다.
        let _ = poi1?.addPoiTappedEventHandler(target: self, handler: StoreMapMarkerViewController.poiTappedHandler) // poi tap event handler를 추가한다.
        poi1?.show()
    }
    
    // POI 탭 이벤트가 발생하고, 표시하고 있던 Poi를 숨긴다.
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        //param.poiItem.hide()
        showPointInfo(title: storeInfo.0, subtitle: storeInfo.1)
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
    
    func showPointInfo(title: String, subtitle: String) {
        let infoView = StoreMapInfoView(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 130), title: title, address: subtitle)
        self.view.addSubview(infoView)
    }
}
