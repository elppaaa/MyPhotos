# 마드라스체크 iOS 사전 과제

## 과제 설명

- 앨범 리스트 및 앨범 내 사진 및 정보를 확인할 수 있는 앱입니다.
- 앱 실행 시 앨범 목록이 표시됩니다.
- 앨범을 선택하면 앨범 내 사진목록이 표시됩니다.
- 사진을 선택하면 사진의 원본 파일 이름과, 용량이 표시됩니다.



## 개발환경


- 기반 환경
  - OS: Mac OS X 11.4
  - IDE: Xcode 12.5.1
  - Swift 5.4
  - Git
- Application
  - UIKit
  - RxSwift
  - Then
  - Photos

## 주요 파일 구조

```
MyPhotos
└── MyPhotos
   ├── Models
   │  ├── Album.swift
   │  ├── PHAsset+Extension.swift
   │  └── PHPhotoCollection+Extension.swift
   ├── Scenes
   │  ├── AlbumListScene
   │  │  ├── AlbumCell.swift
   │  │  ├── AlbumListViewController.swift
   │  │  └── AlbumListViewModel.swift
   │  └── AlbumScene
   │     ├── AlbumViewController.swift
   │     ├── AlbumViewModel.swift
   │     └── AssetCell.swift
   └── Utils
      ├── NSObject+Extension.swift
      └── PhotoLibraryManager.swift

```

- `Album` : 앨범 데이터를 담는 모델 구조체입니다.
- `PHAsset+Extension` : 이미지 / 비디오 등의 정보를 갖는 `PHAsset` 클래스에서 파일 이름, 용량 정보, 이미지 를 가져오기 위한 프로퍼티를 정의합니다.
- `PHPhotoCollection+Extension` : `PHAsset` 의 컬렉션인 `PHPhotoCollection` 에 속한 `PHAsset` 들을 가져오기 위한 함수가 정의되어 있습니다.
- `AlbumListScene` : 초기 화면인 앨범 목록 화면을 구성하기 위한 씬입니다.
- `AlbumScene` : 해당 앨범의 사진을 표시하고 이미지 정보 표시하는 씬입니다.
- `PhotoLibararyManager` : 사진 접근 권한 획득 및 앨범 정보를 수집합니다.

## 스크린샷

#### 앨범 목록 화면

<img src="images/ 2021-07-22 at 20.14.56.png" alt=" 2021-07-22 at 20.14.56" width="25%;" />  

#### 앨범 화면

<img src="images/ 2021-07-22 at 20.14.58.png" alt=" 2021-07-22 at 20.14.58" width="25%;" /> 

#### 이미지 선택 시

<img src="images/ 2021-07-22 at 20.15.03.png" alt=" 2021-07-22 at 20.15.03" width="25%;" />


