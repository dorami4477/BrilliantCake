//
//  CreatePostViewController.swift
//  BrilliantCake
//
//  Created by 박다현 on 8/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class CreatePostViewController: BaseViewController {

    let mainView = CreatePostView()
    let disposeBag = DisposeBag()
    let viewModel: CreatePostViewModel
    
    init(viewModel: CreatePostViewModel) {
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
    
    func bind() {
//        let image = UIImage(named: "BC_5")!
//        let jpgImageData = image.jpegData(compressionQuality: 0.2) ?? Data()
//        let query = CreatePostQuery(title: "hh", content: "eert", content1: "rtyrt", content2: "rttt", product_id: "yyy", files: nil)
        
        //mainView.titleTextField.rx.text.orEmpty
        //mainView.contentTextView.rx.text.orEmpty
        
//        let input = CreatePostViewModel.Input(imageData: Observable.just([jpgImageData]), postData: Observable.just(query), pickerViewTap: mainView.addPhotoButton.rx.tap)
                let input = CreatePostViewModel.Input(pickerViewTap: mainView.addPhotoButton.rx.tap)
        let output = viewModel.transform(input: input)
       
        output.postResult
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        output.pickerViewTap
            .bind(with: self) { owner, _ in
                print("버튼 눌림")
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 3
                configuration.filter = .any(of: [.screenshots, .images])

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func configureLayout() {
        navigationItem.title = "업로드 하기"
        view.backgroundColor = .backgroundGray
    }
}

//델리게이트로 저장
extension CreatePostViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                   // self.photoImageView.image = image as? UIImage
                }
            }
        }
    }
}
