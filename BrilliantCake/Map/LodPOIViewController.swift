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
    let _layerNames: [String] = ["kangnam"]
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
        let kangnam = LodLabelLayerOptions(layerID: "cakeShop", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10000, radius: _radius)

        let _ = manager.addLodLabelLayer(option: kangnam)
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
            storeDatas(layerIndex: index) { storeDatas, options, points in
                let layer = manager.getLodLabelLayer(layerID: self._layerNames[index])
                let lodPois = layer?.addLodPois(options: options, at: points)
                lodPois?.enumerated().forEach{ index, poi in
                    poi.userObject = storeMapData(id: storeDatas[index].id, title: storeDatas[index].title, address: storeDatas[index].content4 ?? "")
                    let _ = poi.addPoiTappedEventHandler(target: self, handler: LodPOIViewController.poiTappedHandler)
                }
                layer?.showAllLodPois()
            }
        }
    }
    

    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        guard let userObject = param.poiItem.userObject, let data = userObject as? storeMapData else { return }
        let vc = StoreMapInfoViewController()
        vc.configureData(id: data.id, title: data.title, address: data.address)
        if let sheet = vc.sheetPresentationController {
             if #available(iOS 16.0, *) {
                 sheet.detents = [
                     .custom { _ in
                         return 180
                     }
                 ]
             } else {
                 sheet.detents = [.medium()]
             }
         }
        self.present(vc, animated: true)
        
    }
    
    func storeDatas(layerIndex: Int, completion: @escaping ([PostData], [PoiOptions], [MapPoint]) -> Void) {
        let input = LodPOIViewModel.Input()
        let output = lodViewModel.transform(input: input)
        
        var storeDatas:[PostData] = []
        var datas = [PoiOptions]()
        var positions = [MapPoint]()

        output.postList
            .subscribe(onNext: { value in
                storeDatas = value
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
                completion(storeDatas, datas, positions)
            })
            .disposed(by: lodDisposeBag)
    }

    
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    

}

class storeMapData {
    let id: String
    let title: String
    let address: String

    init(id: String, title: String, address: String) {
        self.id = id
        self.title = title
        self.address = address
    }
}



