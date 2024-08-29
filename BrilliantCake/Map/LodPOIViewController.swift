//
//  LodPOISample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import RxSwift
import KakaoMapsSDK


class LodPOIViewController: MapViewController {
    private let lodViewModel: LodPOIViewModel
    var _radius: Float = 20.0
    let _layerNames: [String] = ["korea", "seoul", "busan"]
    let lodDisposeBag = DisposeBag()
    
    init(lodViewModel: LodPOIViewModel) {
        self.lodViewModel = lodViewModel
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.028759, latitude: 37.498061)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        createPoiStyle()
        createLodLabelLayer()
        createLodPois()
    }
    
    func createLodLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        // LodLabelLayer를 생성하기 위한 Option.
        // LodLayer에서는 효율적인 계산을 위해 POI의 중심에서 일정 반경(radius, 단위 : pixel)의 원으로 겹치는지를 확인한다.
        let kangnam = LodLabelLayerOptions(layerID: "cakeShop", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10000, radius: _radius)
        let busan = LodLabelLayerOptions(layerID: "busan", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001, radius: _radius)
        let korea = LodLabelLayerOptions(layerID: "korea", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10002, radius: _radius)

        let _ = manager.addLodLabelLayer(option: kangnam)
        let _ = manager.addLodLabelLayer(option: busan)
        let _ = manager.addLodLabelLayer(option: korea)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let resizedImage = resizeImage(image: UIImage(named: ImageName.mapPointer)!, targetSize: CGSize(width: 45, height: 45))
        
        let symbols = [
            resizedImage,
            resizedImage,
            resizedImage
        ]
        
        // 같은 그룹내 경쟁속성이 들어갔을 경우, radius는 symbol width 혹은 height의 1/2로 권장.
        _radius = Float(symbols[0].size.width / 2.0)
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

        for index in 0 ..< _layerNames.count {
            storeDatas(layerIndex: index) { options, points in
                let layer = manager.getLodLabelLayer(layerID: self._layerNames[index])
                let _ = layer?.addLodPois(options: options, at: points)
                layer?.showAllLodPois()
            }
        }
    }
    
    
    func storeDatas(layerIndex: Int, completion: @escaping ([PoiOptions], [MapPoint]) -> Void) {
        let input = LodPOIViewModel.Input()
        let output = lodViewModel.transform(input: input)
        
        var datas = [PoiOptions]()
        var positions = [MapPoint]()

        output.postList
            .subscribe(onNext: { value in
                value.forEach { data in
                    let options = PoiOptions(styleID: "customStyle" + String(layerIndex))
                    
                    options.transformType = .decal
                    options.clickable = true
                    options.addText(PoiText(text: data.title, styleIndex: 0))
                    
                    datas.append(options)
                    if let coordi = data.content3?.convertCSVStringToArray {
                        positions.append(MapPoint(longitude: coordi[0], latitude: coordi[1]))
                    }
                }
                completion(datas, positions)
            })
            .disposed(by: lodDisposeBag)
    }

    
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    

}
