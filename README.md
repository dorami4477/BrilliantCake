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
 
## 3. 트러블 슈팅

### 💥3-1. 많은 양의 서버 통신의 관리 이슈

너무 많은 서버 통신 요청이 발생하며 API 관리의 복잡성과 어려움이 커졌습니다. 또한 다양한 에러 상태 코드에 대해 통일된 처리 방식을 구현하는 데 고민이 있었습니다.

**해결 방법**

1. **각 분야별 라우터 및 네트워크 매니저 분리**:
    
    각 기능별로 통신 로직을 분리하고 모듈화하여 하여 기능별로 독립적으로 관리되도록 하였습니다.
    
2. **공통 네트워크 관리 싱글톤 생성**:
   
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
   ```
