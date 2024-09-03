# BrilliantCake
## 1. 프로젝트 소개
케이크 후기 탐색부터 구매까지, 원하는 케이크를 한 곳에서 손쉽게 찾고 즐기는 올인원 플랫폼.

### 1-1. 환경 설정
최소버전 iPhone iOS15 이상, 라이트모드, 세로형 Portrait 전용

### 1-2. 기술스택
UIKit, RXSwift, MVVM Pattern, Input-Output Pattern, Router Pattern, RxDataSource, 
Kingfisher, Alamofire, KakaoMap, Snapkit, IQKeyboardManagerSwift, CoreLocation
### 1-3. 핵심적인 기능 
- **브라우징 및 검색** : 다양한 케이크 후기를 탐색하고, 댓글 작성 및 해쉬태그 검색 기능을 통해 원하는 케이크 게시글을 찾아 볼 수 있습니다.
- **나의 게시글 관리** : 내가 작성한 후기글을 한 곳에서 모아보고 관리 할 수 있습니다.
- **즐겨찾기** : 마음에 드는 케이크 상점 정보를 확인하고 즐겨찾기 저장 할 수 있습니다.
- **지도 탐색** : 지도를 통해 주변 케이크 상점을 손쉽게 탐색 할 수 있습니다.
- **결제 시스템** : 앱 내에서 원하는 상점의 케이크를 구매 가능합니다.

## 3.  어플 핵심 화면
|탐색&검색 화면|글 등록 화면|지도 화면|
|:---:|:---:|:---:|
|![SHANA KakaoTalk_20240902_215425355](https://github.com/user-attachments/assets/0ad5072c-8f86-4f15-96fd-ec61c77c248d)|![SHANA KakaoTalk_20240902_215424158](https://github.com/user-attachments/assets/d0a44fe6-cefa-4775-89ee-0e6fefc57e56)|![SHANA KakaoTalk_20240902_215424452](https://github.com/user-attachments/assets/2acd81f2-469a-4396-9329-1a5f82f4c005)|
|결제 화면|스토어 화면|마이페이지|
|![SHANA KakaoTalk_20240902_215819437](https://github.com/user-attachments/assets/5a852923-3b88-438e-a849-fecd0c8d911f)|![SHANA KakaoTalk_20240902_215423408](https://github.com/user-attachments/assets/17b2ceb7-cd35-4a62-8d26-0f495d2eba6d)|![SHANA KakaoTalk_20240902_215423731](https://github.com/user-attachments/assets/49681995-ff47-40c1-a268-acbb75e4a2ab)|
## 4.  트러블 슈팅
### 4-1. 페이지네이션 문제
#### 문제
페이지네이션 기능으로 인해 여러 통신 결과가 한 화면에서 섞이는 현상이 발생했습니다. 한 화면에서 3개의 통신이 이루어지며, 각각의 통신이 많은 데이터를 다룰 때 페이지네이션이 필요합니다. 다음과 같은 상황에서 결과물이 섞여 혼동이 발생했습니다:

- 검색 결과와 검색의 페이지네이션
- 일반 게시글과 일반 게시글의 페이지네이션
- 마이페이지 게시물과 마이페이지의 페이지네이션

#### 원인
1. **`firstLoad` 로직 오류**: 검색 모드와 일반 모드 간 전환 시 `firstLoad` 플래그가 제대로 동작하지 않아 데이터 병합 또는 교체에 오류가 발생했습니다.
2. **검색 모드와 커서 처리 문제**: `isSearchMode`가 적절히 전환되지 않아 검색 모드와 일반 모드에서 데이터 스트림이 혼재되어 잘못된 데이터를 보여주었습니다.

#### 해결방법
1. **스트림 분리 및 병합**:
    - **스트림 1**: 일반 게시물과 마이페이지 게시물. `isMyPage` 플래그를 사용해 구분합니다.
    - **스트림 2**: 검색 스트림. 검색 버튼을 클릭 시 `isSearchMode`를 활성화하여 검색을 수행합니다.
    - **스트림 3**: 검색 페이지네이션. 검색 모드(`isSearchMode`)가 활성화되고, `nextCursor` 값이 변화할 때 실행됩니다.
    
    이 3개의 스트림은 모두 `Single<Result<PostModel, PostNetworkError>>` 타입을 반환하며, 이를 병합(`merge`)하여 하나의 일관된 결과물을 보여주도록 했습니다.
    
2. **`firstLoad` 로직 개선**: 
검색 모드 또는 일반 모드로 전환할 때마다 `firstLoad` 플래그를 적절히 리셋하여, 데이터가 병합(append) 또는 교체(replace)될 때 올바르게 처리되도록 함.
    - 검색 모드에 들어갈 때는 항상 `firstLoad`를 `true`로 설정.
    - 검색 모드와 일반 모드를 전환할 때 `firstLoad`가 올바르게 적용되어 데이터를 새로 불러오거나, 이어서 불러오도록 조정.
3. **검색 및 페이지네이션 스트림 관리**:
    - `Observable.combineLatest` 및 `searchMoreStream`을 통해 검색과 페이지네이션 스트림을 분리한 후 병합하여, 각각의 모드에서 올바르게 데이터가 로드되도록 했습니다.
    - 추가 필터링과 조건을 통해 데이터가 섞이는 현상을 방지하고, 모드에 따라 적절한 데이터를 화면에 보여주도록 수정했습니다.

#### 코드
```Swift
let postList = PublishSubject<[PostData]>()
let isTokenVaild = BehaviorSubject(value: true)
          //스트림 1
            let normalPostStream = Observable.combineLatest(isMyPage, nextCursor, isSearchMode)
                .filter { !$0.2 }
                .flatMapLatest { isMyPage, cursor, _ -> Single<Result<PostModel, PostNetworkError>> in
                    if isMyPage {
                        return PostNetworkManager.shared.fetchUserPost(id: UserDefaultsManager.userID, next: cursor)
                    } else {
                        return PostNetworkManager.shared.fetchPost(next: cursor, limit: "15", productId: ProductId.allBCake.rawValue)
                    }
                }
          //스트림 2
            let searchStream = input.searchButtonTap
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(input.textField)
                .do(onNext: { [weak self] _ in self?.isSearchMode.accept(true) })
                .flatMap { value -> Single<Result<PostModel, PostNetworkError>> in
                    self.firstLoad = true
                    let query = SearchQuery(next: "", limit: "13", product_id: ProductId.allBCake.rawValue, hashTag: value)
                    return PostNetworkManager.shared.searchWithHashTag(query: query)
                }
          //스트림 3
            let searchMoreStream = Observable.combineLatest(isSearchMode.asObservable(), nextCursor, input.textField)
                .filter { $0.0 && $0.1 != "" }
                .flatMap { _, cursor, inputText -> Single<Result<PostModel, PostNetworkError>> in
                    let query = SearchQuery(next: cursor, limit: "13", product_id: ProductId.allBCake.rawValue, hashTag: inputText)
                    return PostNetworkManager.shared.searchWithHashTag(query: query)
                }
          //스트림 병합
            Observable.merge(normalPostStream, searchStream, searchMoreStream)
                .subscribe(with: self, onNext: { owner, result in
                    switch result {
                    case .success(let value):
                        owner.data1 = value
                        if owner.firstLoad {
                            owner.data = value.data
                            owner.firstLoad = false
                            
                        } else {
                            owner.data.append(contentsOf: value.data)
                        }

                        postList.onNext(owner.data)
                    case .failure(let error):
                        print(error)
                        if error == .expiredToken {
                            isTokenVaild.onNext(false)
                        }
                    }
                })
                .disposed(by: disposeBag)
```
### 4-2. 많은 양의 네트워크 통신 문제
#### 문제:

너무 많은 서버 통신 요청이 동시에 발생하며 API 관리의 복잡성과 어려움이 커졌습니다. 또한 다양한 에러 상태 코드에 대해 통일된 처리 방식을 구현하는 데 고민이 있었습니다.

#### 해결 방법:

1. **각 분야별 라우터 및 네트워크 매니저 분리**:
    - 각 기능별로 통신 로직을 분리하여 모듈화: `PaymentRouter`, `PostRouter`, `UserRouter`와 같은 라우터와, `PaymentNetworkManager`, `PostNetworkManager`, `UserNetworkManager`를 각각 생성하여 기능별로 독립적으로 관리되도록 함.
2. **공통 네트워크 관리 싱글톤 생성**:
    - 반복되는 코드 및 에러 처리를 줄이기 위해 공통 네트워크 관리 Enum(`NetworkManager`)을 생성하여 관리.
    - `Alamofire`을 통한 통신 및 `interceptor`를 이용한 토큰 재발급 등의 통신을 한 곳에서 처리하여 통신 코드의 일관성 유지.
    - 공통 에러 처리를 한 번에 관리하기 위해 공통 에러 enum을 만들어, 여러 네트워크 요청에서 발생하는 에러를 일관되게 처리할 수 있도록 개선.
3. **통신에 따른 세분화된 에러 처리**:
    - 각 네트워크 요청에서 각기 다른 상황에 맞는 에러 enum 타입을 정의하여 처리. 예를 들어, `PaymentNetworkError`는 결제와 관련된 에러를 세분화하여 처리함.
    - 공통 에러(`NetworkError`)와 세부 에러(`PaymentNetworkError`)를 함께 사용하여 상황에 맞는 적절한 에러 처리가 가능하도록 구조를 확장.

#### 코드
1) 공통 네트워크 관리
- 공통된 에러를 처리하기 위한 NetworkError enum을 정의하였고, 이를 통해 상태 코드를 처리함.
- 공통의 네트워크 요청, 토근 만료로 인한 재시도 등의 통신을 한 곳에 관리.
- 각 통신별 상태코드는 unknownError타입으로 상태코드와 함께 넘겨주도록 함.
```Swift
enum NetworkError: Error, Equatable {
    case invaildURL
    case expiredToken
    case unknownError(statusCode: Int)
    case serverError
    case headerError
    case exceededRequest
    
    var statusCode: Int {
        switch self {
        case .invaildURL: return 444
        case .expiredToken: return 418
        case .unknownError(let statusCode): return statusCode
        case .serverError: return 500
        case .headerError: return 420
        case .exceededRequest: return 429
        }
    }
}

enum NetworkManager {
    static func callRequest<Model: Decodable>(model: Model.Type, request: URLRequest, completion: @escaping (Result<Model, NetworkError>) -> Void) {
        AF.request(request, interceptor: AuthInterceptor.shared)
            .responseDecodable(of: model.self) { response in
                switch response.result {
                case .success(let success):
                    completion(.success(success))
                case .failure:
                    guard let response = response.response else { return }
                    switch response.statusCode {
                    case NetworkError.expiredToken.statusCode:
                        completion(.failure(.expiredToken))
                    case NetworkError.headerError.statusCode:
                        completion(.failure(.headerError))
                    ...
                    default:
                        completion(.failure(.unknownError(statusCode: response.statusCode)))
                    }
                }
            }
    }
}
```
2) 각 기능별 네트워크
- 결제 관련 네트워크 요청은 PaymentNetworkManager에서 관리하며, 각기 다른 상황에 맞는 PaymentNetworkError enum을 정의하여 에러를 처리.
- 결제 과정에서 발생하는 특정 에러(alreadyDone, invalid, expiredToken 등)를 분리하여 세부적으로 처리함으로써, 에러에 대한 명확한 핸들링이 가능하도록 개선.
```Swift
enum PaymentNetworkError: Error, Equatable {
    case invalid
    case unknownAccessToken
    case forbidden
    case alreadyDone
    case expiredToken
    case commonError(error: NetworkError)
    
    var statusCode: Int {
    ...
}

final class PaymentNetworkManager {
    static let shared = PaymentNetworkManager()
    private init() {}

    func validation(impId: String, postId: String) -> Single<Result<ValidationModel, PaymentNetworkError>> {
        return Single.create { observer -> Disposable in
            do {
                let query = ValidationQuery(imp_uid: impId, post_id: postId)
                let request = try PaymentRouter.validation(query: query).asURLRequest()
                
                NetworkManager.callRequest(model: ValidationModel.self, request: request) { result in
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        switch error {
                        case .unknownError(statusCode: PaymentNetworkError.invalid.statusCode):
                            observer(.success(.failure(.invalid)))
                        case .unknownError(statusCode: PaymentNetworkError.unknownAccessToken.statusCode):
                            observer(.success(.failure(.unknownAccessToken)))
                        case .unknownError(statusCode: PaymentNetworkError.forbidden.statusCode):

                        ...

```
