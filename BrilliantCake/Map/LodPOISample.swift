//
//  LodPOISample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

class LodPOISample: MapViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createPoiStyle()
        createLodLabelLayer()
        createLodPois()
    }
    
    func createLodLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        // LodLabelLayer를 생성하기 위한 Option.
        // LodLayer에서는 효율적인 계산을 위해 POI의 중심에서 일정 반경(radius, 단위 : pixel)의 원으로 겹치는지를 확인한다.
        let seoul = LodLabelLayerOptions(layerID: "seoul", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10000, radius: _radius)
        let busan = LodLabelLayerOptions(layerID: "busan", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001, radius: _radius)
        let korea = LodLabelLayerOptions(layerID: "korea", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10002, radius: _radius)

        let _ = manager.addLodLabelLayer(option: seoul)
        let _ = manager.addLodLabelLayer(option: busan)
        let _ = manager.addLodLabelLayer(option: korea)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let symbols = [
            UIImage(named: ImageName.mapPointer),
            UIImage(named: ImageName.mapPointer),
            UIImage(named: ImageName.mapPointer)
        ]
        
        // 같은 그룹내 경쟁속성이 들어갔을 경우, radius는 symbol width 혹은 height의 1/2로 권장.
        _radius = Float(symbols[0]!.size.width / 2.0)
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let textLineStyles = [
            PoiTextLineStyle(textStyle: TextStyle(fontSize: 15, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))),
            PoiTextLineStyle(textStyle: TextStyle(fontSize: 12, fontColor: UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0), strokeThickness: 1, strokeColor: UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)))
        ]

        for index in 0 ... 2 {
            let iconStyle = PoiIconStyle(symbol: symbols[index], anchorPoint: anchorPoint)
            let textStyle = PoiTextStyle(textLineStyles: textLineStyles)
            textStyle.textLayouts = [.bottom]
            let poiStyle = PoiStyle(styleID: "customStyle" + String(index), styles: [
                // padding을 -2로 설정하면 패닝시 깜빡거리는 현상을 최소화 할 수 있다.
                PerLevelPoiStyle(iconStyle: iconStyle, textStyle: textStyle, padding: -2.0, level: 0)
            ])
            
            
            manager.addPoiStyle(poiStyle)
        }
    }
    
    func createLodPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        for index in 0 ... (_layerNames.count - 1) {
            let datas = testLodDatas(layerIndex: index)
            let layer = manager.getLodLabelLayer(layerID: _layerNames[index])
            
            let _ = layer?.addLodPois(options: datas.0, at: datas.1)    // 대량의 POI를 add할때는 개별로 add하기 보다는 addPois를 사용하는 것이 효율적이다.
            layer?.showAllLodPois()
        }
    }
    
    func testLodDatas(layerIndex: Int) -> ([PoiOptions], [MapPoint]) {
        var datas = [PoiOptions]()
        var positions = [MapPoint]()
        
        var coords = [MapPoint]()
        var boundary = [GeoCoordinate]()

        coords.append(MapPoint(longitude: 126.627459, latitude: 35.129776))
        coords.append(MapPoint(longitude: 126.875658, latitude: 37.492889))
        coords.append(MapPoint(longitude: 128.774832, latitude: 35.126031))

        boundary.append(GeoCoordinate(longitude: 2.694945, latitude: 3.590908))
        boundary.append(GeoCoordinate(longitude: 0.269494, latitude: 0.179662))
        boundary.append(GeoCoordinate(longitude: 0.359326, latitude: 0.628808))

        for index in 1 ... 1000 {
            let options = PoiOptions(styleID: "customStyle" + String(layerIndex))
            options.rank = Int(index)
            let coord = coords[layerIndex].wgsCoord
            
            options.transformType = .decal
            options.clickable = true
            options.addText(PoiText(text: _layerNames[layerIndex], styleIndex: 0))
            options.addText(PoiText(text: String(index), styleIndex: 1))

            datas.append(options)
            positions.append(MapPoint(longitude: coord.longitude + Double.random(in: 0...boundary[layerIndex].longitude),
                                      latitude: coord.latitude + Double.random(in: 0...boundary[layerIndex].latitude)))
        }
        
        return (datas, positions)
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    
    var _radius: Float = 20.0
    let _layerNames: [String] = ["korea", "seoul", "busan"]
}
