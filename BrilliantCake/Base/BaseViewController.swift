//
//  BaseViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/14/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        configureHierarchy()
        configureLayout()
        configureNavigation()
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureNavigation(){}
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeRootVC(_ viewController:UIViewController){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func showToast(message : String) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-200, width: 250, height: 65))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            toastLabel.textColor = UIColor.white
            toastLabel.numberOfLines = 0
            toastLabel.font = AppFont.size14
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    

    func showAlert(title:String, message:String?, buttonTilte:String, completionHandler:@escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: buttonTilte, style: .destructive, handler: completionHandler)
        let cancel = UIAlertAction(title: Literal.ButtonName.cancel, style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func screenSize() -> CGRect {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return CGRect() }
        let screenSize = window.screen.bounds
        return screenSize
    }
    
    
    func isExpiredToken(_ value: Bool){
        if !value {
            showAlert(title: Literal.ButtonName.expiredToken, message: Literal.GuideMessage.expiredToken, buttonTilte: Literal.ButtonName.comform) { [weak self] _ in
                let loginVC = LoginViewController()
                self?.changeRootVC(loginVC)
            }
        }
    }
}

