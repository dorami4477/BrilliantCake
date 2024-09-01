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

final class CreatePostViewController: BaseViewController {

    private let mainView = CreatePostView()
    private let disposeBag = DisposeBag()
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
    
    private func bind() {
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
                configuration.selectionLimit = 4
                configuration.filter = .any(of: [.screenshots, .images])

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.contentTextView.rx.text.orEmpty
            .bind(with: self) { owner, value in
                if value.count > 200 {
                    owner.mainView.contentTextView.text = String(value.prefix(200))
                }
                owner.mainView.contentCountLabel.text = "\(min(value.count, 200)) / 200"
            }
            .disposed(by: disposeBag)
        
        mainView.titleTextField.rx.text.orEmpty
            .bind(with: self) { owner, value in
                if value.count > 30 {
                    owner.mainView.titleTextField.text = String(value.prefix(30))
                }
                owner.mainView.titleCountLabel.text = "\(min(value.count, 30)) / 30"
            }
            .disposed(by: disposeBag)
        
        output.submitButtonActive
            .bind(with: self, onNext: { owner, value in
                owner.mainView.setSubmitButton(value)
            })
            .disposed(by: disposeBag)
    }

    override func configureLayout() {
        navigationItem.title = Literal.ViewTitle.createPost
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
                                
                                var compressionQuality: CGFloat = 0.9
                                var jpgImageData = loadedImage.jpegData(compressionQuality: compressionQuality) ?? Data()

                                let maxFileSize: Int = 5 * 1024 * 1024
                                while jpgImageData.count > maxFileSize && compressionQuality > 0.1 {
                                    compressionQuality -= 0.1
                                    jpgImageData = loadedImage.jpegData(compressionQuality: compressionQuality) ?? Data()
                                }

                                selectedImageDatas.append(jpgImageData)
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
            }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.mainView.addNewImages(images: selectedImages)
            self.mainView.photoCountLabel.text = "\(selectedImages.count) / 4"
            self.viewModel.imageData.onNext(selectedImageDatas)
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
               textView.text = Literal.GuideMessage.contentPlaceholder
               textView.textColor = UIColor.lightGray
           }
       }
}

