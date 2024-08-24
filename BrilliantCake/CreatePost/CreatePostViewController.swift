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
        let input = CreatePostViewModel.Input(titleText: mainView.titleTextField.rx.text.orEmpty,
                                              contentText: mainView.contentTextView.rx.text.orEmpty,
                                              storeButtonTap: mainView.storeSelectButton.rx.tap,
                                              pickerViewTap: mainView.addPhotoButton.rx.tap,
                                              submitButtonTap: mainView.submitButton.rx.tap)
        let output = viewModel.transform(input: input)
       
        output.postResult
            .bind(with: self) { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        input.storeButtonTap
            .bind(with: self) { owner, value in
                let storeVC = SelectStoreViewController(viewModel: SelectStoreViewModel())
                storeVC.viewModel.selectedStore
                    .bind(with: self) { owner, value in
                        owner.mainView.storeSelectButtonUI(title: value.title)
                        owner.viewModel.storeID.onNext(value.id)
                        owner.viewModel.storeName.onNext(value.title)
                    }
                    .disposed(by: storeVC.viewModel.disposeBag)
                
                owner.navigationController?.pushViewController(storeVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.pickerViewTap
            .bind(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 3
                configuration.filter = .any(of: [.screenshots, .images])

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.submitButtonActive
            .bind(with: self, onNext: { owner, value in
                owner.mainView.setSubmitButton(value)
            })
            .disposed(by: disposeBag)
    }

    override func configureLayout() {
        navigationItem.title = "업로드 하기"
        view.backgroundColor = .backgroundGray
        mainView.contentTextView.delegate = self
    }
}


extension CreatePostViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        var selectedImages: [UIImage] = []
        var selectedImageDatas: [Data] = []
        let dispatchGroup = DispatchGroup()

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()

                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let loadedImage = image as? UIImage {
                            selectedImages.append(loadedImage)
                            let jpgImageData = loadedImage.jpegData(compressionQuality: 0.7) ?? Data()
                            selectedImageDatas.append(jpgImageData)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.mainView.addNewImages(images: selectedImages)
            self?.viewModel.imageData.onNext(selectedImageDatas)
        }
    }

}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == UIColor.lightGray {
               textView.text = nil
               textView.textColor = UIColor.black
           }
           
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "방문하신 스토어에 대한 후기의 내용을 적어주세요."
               textView.textColor = UIColor.lightGray
           }
       }
}
