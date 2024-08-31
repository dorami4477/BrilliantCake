//
//  StoreViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

final class StoreViewController: BaseViewController {
    private let mainView = StoreView()
    private let viewModel: StoreViewModel
    private let disposeBag = DisposeBag()
    var storeId: String = ""
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    init(viewModel: StoreViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = StoreViewModel.Input(storeId: Observable.just(storeId),
                                         modelSelected: mainView.collectionView.rx.modelSelected(PostData.self), 
                                         mapButtonTap: mainView.locationButton.rx.tap, 
                                         likeButtonTap: navigationItem.rightBarButtonItem?.rx.tap,
                                         purchaseButtonTap: mainView.purchaseButton.rx.tap
        )
        let output = viewModel.transform(input: input)

        output.postList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: DetailPostingCVCell.identifier, cellType: DetailPostingCVCell.self)){ index, item, cell in
                cell.mainImageView.setImage(url: item.files[0])
            }
            .disposed(by: disposeBag)
        
        output.storeData
            .bind(with: self) { owner, value in
                owner.mainView.titleLabel.text = value.title
                owner.mainView.descriptionLabel.text = value.content
                owner.mainView.contactLabel.text = value.content1
                owner.mainView.callButton.setTitle(" \(value.content2)", for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.postList
            .withUnretained(self)
            .map{ owner, value in
                var colum = value.count / 3
                let last = value.count % 3
                if last > 0 {
                    colum += 1
                }
                return Int(owner.screenSize().width) / 3 * colum
            }
            .bind(with: self) { owner, value in
                owner.mainView.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(value)
                }
            }
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self) { owner, value in
                let detailVC = DetailPostingViewController(viewModel: DetailPostingViewModel())
                detailVC.viewModel.data = value
                detailVC.mainView.storeButton.isHidden = true
                owner.present(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.storeData
            .map{ value in
                value.files
            }
            .bind(with: self) { owner, value in
                owner.mainView.cakeImageView1.setImage(url: value[0])
                owner.mainView.cakeImageView2.setImage(url: value[1])
                owner.mainView.cakeImageView3.setImage(url: value[2])
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(output.mapCoord, output.storeData)
            .bind(with: self) { owner, value in
                let mapVC = StoreMapMarkerViewController(viewModel: MapViewModel())
                mapVC.coord = value.0
                guard let address = value.1.content4 else { return }
                mapVC.storeInfo = (value.1.title, address)
                owner.navigationController?.pushViewController(mapVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.like
            .bind(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.image = value ? UIImage(systemName: ImageName.heartFill) : UIImage(systemName: ImageName.heart)
                owner.navigationItem.rightBarButtonItem?.tintColor = value ? .main : .black
            }
            .disposed(by: disposeBag)
        
        output.isTokenVaild
            .bind(with: self) { owner, value in
                owner.isExpiredToken(value)
            }
            .disposed(by: disposeBag)
        
        output.purchaseButtonTap
            .withLatestFrom(output.storeData)
            .bind(with: self, onNext: { owner, value in
                guard let price = value.price else { return }
                owner.payment(productName: value.title, amount: "\(price)")
            })
            .disposed(by: disposeBag)
    }

    func payment(productName: String, amount: String) {
        let payment = IamportPayment(
                pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                merchant_uid: "ios_\(APIKey.key)_\(Int(Date().timeIntervalSince1970))",
                amount: amount).then {
        $0.pay_method = PayMethod.card.rawValue 
        $0.name = productName
        $0.buyer_name = "박다현"
        $0.app_scheme = "sesac"
        }
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: PaymentKey.userCode,
            payment: payment) { [weak self] iamportResponse in
                self?.paymentCallback(iamportResponse)
            }
        
        setupWebView()
    }
    
    private func setupWebView() {
        view.addSubview(wkWebView)
        navigationController?.navigationBar.isHidden = true
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func paymentCallback(_ response: IamportResponse?) {
        guard let response else { return }
        let resultVC = PaymentResultViewController(viewModel: PaymentViewModel())
        resultVC.impResponseRelay.accept(response)
        resultVC.viewModel.productID = storeId
        navigationController?.pushViewController(resultVC, animated: true)
    }

    
    override func configureNavigation() {
        let likeButton = UIBarButtonItem(image: UIImage(systemName: ImageName.heart))
        navigationItem.rightBarButtonItem = likeButton
    }
    

    
    override func configureLayout() {
        mainView.collectionView.register(DetailPostingCVCell.self, forCellWithReuseIdentifier: DetailPostingCVCell.identifier)
    }
    
    func touchUpForCalling(number: String) {
        if let url = NSURL(string: "tel://0" + "\(number)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
