# SwiftDesignLab

좋은 디자인과 UX를 SwiftUI와 UIKit으로 구현해보는 디자인 실험실입니다.

## 프로젝트 소개

SwiftDesignLab은 iOS 개발에서 자주 사용되는 디자인 패턴과 사용자 경험(UX) 요소들을 실제 코드로 구현하고 실험하는 프로젝트입니다. SwiftUI와 UIKit 두 가지 프레임워크를 모두 활용하여 다양한 디자인 접근 방식을 탐구합니다.

### 아키텍처

```
SwiftDesignLab/
├── App/                   # 앱 진입점
├── Coordinator/           # 코디네이터 패턴
│   ├── Core/             # 코디네이터 핵심 구현
│   ├── SwiftUI/          # SwiftUI 탭 코디네이터
│   └── UIKit/            # UIKit 탭 코디네이터
├── View/                  # 뷰 계층
│   ├── Common/           # 공통 뷰 컴포넌트
│   ├── SwiftUI/          # SwiftUI 탭
│   └── UIKit/            # UIKit 탭
├── Model/                 # 데이터 모델
├── DI/                   # 의존성 주입
└── Asset/                # 앱 리소스
```

## SwiftUI

### 1. FitVolumeView
`FitVolumeView`는 "Nightly" 라는 앱에서 발견한 인터렉티브한 디자인입니다.
사용자가 휴대폰 볼륨을 조절할 때 추천 볼륨과 일치하는 순간에 뷰가 하나로 합쳐집니다.

![FitVolume Demo](img/FitVolume.gif)



## 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다. 자세한 내용은 [LICENSE.md](LICENSE.md) 파일을 참조하세요.