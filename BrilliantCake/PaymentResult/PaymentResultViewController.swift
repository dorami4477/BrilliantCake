//
//  PaymentResultViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import iamport_ios

class PaymentResultViewController: BaseViewController {
    
    let impResponseRelay = BehaviorRelay<IamportResponse?>(value: nil)
    let viewModel: PaymentViewModel
    var disposeBag = DisposeBag()
    
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

    }
    
    func bind() {
        let input = PaymentViewModel.Input(impResponse: impResponseRelay)
        let output = viewModel.transform(input: input)
        
        output.validPayment
            .subscribe(onNext: { [weak self] value in
                 guard let self = self else { return }
                 self.showAlert(title: "결제완료", message: "결제가 완료되었습니다. 감사합니다.", buttonTilte: "확인") { _ in
                     let myTabBar = TabBarController()
                     myTabBar.selectedIndex = 3

                     if let navController = myTabBar.viewControllers?[3] as? UINavigationController {
                         let paymentListVC = ProfileViewController(viewModel: ProfileViewModel())
                         navController.setViewControllers([paymentListVC], animated: false)
                         
                         let detailVC = PaymentListViewController(viewModel: PaymemtListViewModel())
                         navController.pushViewController(detailVC, animated: true)
                     }
                     
                     self.changeRootVC(myTabBar)
                 }
             })
            .disposed(by: disposeBag)
        
        output.errorStatus
            .bind(with: self) { owner, value in
                if value == .expiredToken {
                    owner.isExpiredToken(true)
                    
                } else if value == .invalid {
                    owner.showAlert(title: "미승인", message: "결제가 정상적으로 처리되지 않았습니다. 재시도 부탁드립니다.", buttonTilte: "확인") { [weak self] _ in
                        guard let viewControllerStack = self?.navigationController?.viewControllers else { return }
                            
                        for viewController in viewControllerStack {
                            if let storeView = viewController as? StoreViewController {
                                self?.navigationController?.popToViewController(storeView, animated: true)
                            }
                        }
                    }
                }

            }
            .disposed(by: disposeBag)
    }

}
