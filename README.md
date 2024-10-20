# BrilliantCake 🎂

> 케이크 후기 탐색부터 구매까지, 원하는 케이크를 한 곳에서 손쉽게 찾고 즐기 수 있는 앱

<div>
<img src="https://github.com/user-attachments/assets/0ad5072c-8f86-4f15-96fd-ec61c77c248d" alt="Image 1" width="16%"/>
<img src="https://github.com/user-attachments/assets/d0a44fe6-cefa-4775-89ee-0e6fefc57e56" alt="Image 1" width="16%"/>
<img src="https://github.com/user-attachments/assets/2acd81f2-469a-4396-9329-1a5f82f4c005" alt="Image 1" width="16%"/>
<img src="https://github.com/user-attachments/assets/5a852923-3b88-438e-a849-fecd0c8d911f" alt="Image 1" width="16%"/>
<img src="https://github.com/user-attachments/assets/17b2ceb7-cd35-4a62-8d26-0f495d2eba6d" alt="Image 1" width="16%"/>
<img src="https://github.com/user-attachments/assets/49681995-ff47-40c1-a268-acbb75e4a2ab" alt="Image 1" width="16%"/>
</div>

## 1. 프로젝트 개요

### 1-1. 개발 환경

개발기간: 2024.8.15 - 2024.8.30 ( 약 2주 )<br>
개발인원: 1명<br>
환경설정: 최소버전 iPhone iOS15 이상, 라이트모드, 세로형 Portrait 전용

### 1-2. 기술스택 및 라이브러리

UI: UIKit, Kingfisher, IQKeyboardManagerSwift, Snapkit <br>
Rective: RXSwift, RxDataSource<br>
Network: Alamofire<br>
Map: KakaoMap, CoreLocation<br>
PG: PortOne SDK<br>
Pattern: MVVM Pattern, Input-Output Pattern, Router Pattern 

### 1-3. 핵심적인 기능

- **브라우징 및 검색** : 다양한 케이크 후기를 탐색하고, 댓글 작성 및 해쉬태그 검색 기능을 통해 원하는 케이크 게시글을 검색
- **나의 게시글 관리** : 내가 작성한 후기글을 한 곳에서 모아보고 관리 가능
- **즐겨찾기** : 마음에 드는 케이크 상점 정보를 확인하고 즐겨찾기 저장
- **지도 탐색** : 지도를 통해 주변 케이크 상점을 손쉽게 탐색
- **결제 시스템** : 앱 내에서 원하는 상점의 케이크를 구매 가능

## 2. 아키텍쳐 및 개발 포인트

![Untitled from FigJam (23)](https://github.com/user-attachments/assets/24261407-79f7-445d-bbf3-27be2792721e)

### 아키텍처

- MVVM, Rxswift
    - MVVM의 Input/Output 패턴을 사용하여 데이터 흐름을 명확히 정의
    - 메모리 효율성을 높이기 위해 로그인 화면 분기 처리 및 사용된 메모리를 해제
    - 각 기능별로 통신 로직을 분리하여 모듈화
    - LikeDataManager를 통해 여러뷰에서 한번에 즐겨찾기 이벤트의 송수신 관리

### 네트워크

- **Alamofire**
    - RequestInterceptor를 이용하여 로그인 토큰 갱신 로직 구현
    - 네트워크 요청 함수에 제네릭 타입을 적용하여 재사용성과 확장성 향상
    - 네트워크 에러 코드를 세분화하여 적절한 네트워크 에러 대응
    - API의 Router에 URLRequestConvertible의 TargetType을 적용하여 네트워크 요청 구성을 일관되게 유지하고 유지보수를 용이성을 높임
    - 페이지네이션으로 성능 최적화 및 네트워크 비용 절감
    - 서버의 영수증 검증 로직 구현으로 이니시스 PG와 결제 연동
    - 불필요한 네트워크 통신을 막기 위해 디바운싱 기법 사용
 
## 3. 트러블 슈팅

### 💥3-1. 많은 양의 서버 통신의 관리 이슈

너무 많은 서버 통신 요청이 발생하며 API 관리의 복잡성과 어려움이 커졌습니다. 또한 다양한 에러 상태 코드에 대해 통일된 처리 방식을 구현하는 데 고민이 있었습니다.

**해결 방법**

1. **각 분야별 라우터 및 네트워크 매니저 분리**:
   
    각 기능별로 통신 로직을 분리하고 모듈화하여 하여 기능별로 독립적으로 관리되도록 하였습니다.
    ```swift
    //기능별 파일명 
    PaymentRouter, PaymentNetworkManger, PostRouter, PostNetworkManager, UserRouter, UserNetworkManager
    ```
    
3. **공통 네트워크 관리 싱글톤 생성**:
   
    재네릭를 사용하여 핵심 서버 통신 매니저를 생성하고, 그 안에서 공통된 토큰 확인 및 에러처리를 함으로써 코드의 재사용성과 확장성을 높이고 관리를 용이하게 변경하였습니다. 
        
   ```swift
    enum NetworkManager {
        static func callRequest<Model: Decodable>(model: Model.Type, request: URLRequest, completion: @escaping (Result<Model, NetworkError>) -> Void) {
    
            AF.request(request, interceptor: AuthInterceptor.shared)
                .responseDecodable(of: model.self) { response in
                    switch response.result {
                    case .success(let success):
                    completion(.success(success))
                    case .failure:
                    ...
                    }
                }
        }
    }
   ```
        
4. **통신에 따른 세분화된 에러 처리**:

    공통 에러(`NetworkError`)와 세부 에러(`PaymentNetworkError`)를 나누어 사용하여, 코드의 재사용성을 높이고 적절한 에러 처리가 가능하도록 변경하였습니다.
        
   ```swift
    enum NetworkError: Error, Equatable { //공통에러
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
            case .unknownError(let statusCode): return statusCode //세부 에러 처리
            case .serverError: return 500
            case .headerError: return 420
            case .exceededRequest: return 429
            }
        }
        
     enum PaymentNetworkError: Error, Equatable { //세부에러
        case invalid
        case unknownAccessToken
        case forbidden
        case alreadyDone
        case expiredToken
        case commonError(error: NetworkError)
    
        var statusCode: Int {
        ...
    }
   ```
### 💥3-2. 페이지네이션 및 통신 데이터 혼선 이슈

**문제**

페이지네이션 기능으로 인해 여러 상황별 통신을 한 화면에서 보여주면서, 데이터가 섞이거나 제대로 나오지 않는 현상이 발생했습니다.
- 네트워크 통신이 필요한 케이스:
    - case1. 일반 게시글
    - case2. 일반 게시글의 페이지네이션
    - case3. 마이페이지 게시물
    - case4. 마이페이지의 페이지네이션
    - case5. 검색 결과
    - case6. 검색의 페이지네이션

**해결방법**
1. **플래그 선언과 스트림 분리/병합:**
   
   스트림은 3가지로 나누어, 변수를 통해 스트림 내에 분기 처리하고, 네트워크 통신 후 스트림을 병합하여 하나의 일관된 결과물을 보여주도록 했습니다.
   
    - **스트림 normalPostStream**: 일반 게시물과 마이페이지 게시물. `isMyPage` 플래그를 사용해 구분합니다.
    - **스트림 searchStream**: 검색 스트림. 검색 버튼을 클릭 시 `isSearchMode`를 활성화하여 검색을 수행합니다.
    - **스트림 searchMoreStream**: 검색 페이지네이션. 검색 모드(`isSearchMode`)가 활성화되고, `nextCursor` 값이 변화할 때 실행됩니다.
    
    이 3개의 스트림을 병합하여 하나의 일관된 결과물을 보여주도록 했습니다.

    ```swift
    let isMyPage = BehaviorSubject(value: false)
    let isSearchMode = BehaviorRelay(value: false)
    var firstLoad = true
    
    //스트림 1
    let normalPostStream = Observable.combineLatest(isMyPage, nextCursor, isSearchMode)
        .filter { !$0.2 } //🍄검색화면 분기처리
        .flatMapLatest { isMyPage, cursor, _ in
            if isMyPage {  //🍄마이페이지 분기처리
                return PostNetworkManager.shared.fetchUserPost(...)
                
            } else {
                return PostNetworkManager.shared.fetchPost(...)
            }
        }
    
    //스트림 2
    let searchStream = input.searchButtonTap
        ...
        .do(onNext: { [weak self] _ in self?.isSearchMode.accept(true) }) //🍄검색모드로 전환
        .flatMap { value in
            self.firstLoad = true //🍄페이지네이션 분기처리
            ...
            return PostNetworkManager.shared.searchWithHashTag(query: query)
        }
    
    //스트림 3
    let searchMoreStream = Observable.combineLatest(isSearchMode.asObservable(), nextCursor, input.textField)
        .filter { $0.0 && $0.1 != "" } //🍄검색모드이고, 페이지네이션 로드일 때 
        .flatMap { _, cursor, inputText in
            ...
            return PostNetworkManager.shared.searchWithHashTag(query: query)
        }
    
    //스트림 병합
    Observable.merge(normalPostStream, searchStream, searchMoreStream)
        .subscribe(with: self, onNext: { owner, result in
            switch result {
            case .success(let value):
                owner.data1 = value
                if owner.firstLoad { //🍄페이지네이션 분기처리
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
## 4. 회고

1. 서버 통신을 관리하는 API의 수가 증가하면서 단순히 앱 기능을 구현하는 것을 넘어, 반복되는 코드를 어떻게 효율적으로 줄이고 유지보수를 용이하게 할 것인가를 많이 고민해 보았던 프로젝트였습니다. API외에 다른 부분도 코드의 재사용성을 높이고 가독성을 개선할 수 있는 방향으로 코드를 리팩토링 해보고 싶습니다.
