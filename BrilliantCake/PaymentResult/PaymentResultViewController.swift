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

final class PaymentResultViewController: BaseViewController {
    
    let impResponseRelay = BehaviorRelay<IamportResponse?>(value: nil)
    let viewModel: PaymentViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    private func bind() {
        let input = PaymentViewModel.Input(impResponse: impResponseRelay)
        let output = viewModel.transform(input: input)
        
        output.validPayment
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.showAlert(title: Literal.GuideMessage.completePayingTitle, message: Literal.GuideMessage.completePaying, buttonTilte: Literal.ButtonName.comform) { _ in
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
                    owner.showAlert(title: Literal.GuideMessage.paymentErrorTitle, message: Literal.GuideMessage.paymentError, buttonTilte: Literal.ButtonName.comform) { [weak self] _ in
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
