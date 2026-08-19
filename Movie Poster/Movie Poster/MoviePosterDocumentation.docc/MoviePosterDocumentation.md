# Movie Poster

영화 포스터를 인식하면 포스터 안쪽에 깊이감 있는 영화관 포털과 일반 Video 예고편을 표시하는 ARKit 학습 프로젝트입니다.

이 문서는 SwiftUI 화면에 RealityKit의 `ARView`를 연결하고, ARKit Image Tracking으로 포스터를 찾은 뒤, `ARImageAnchor`에 3D 포털과 `VideoMaterial`을 배치하는 과정을 설명합니다.

> Important: 이 프로젝트는 Spatial Video가 아니라 일반적인 2D Video를 사용합니다. 먼저 Image Tracking, 앵커, 3D 좌표, `AVPlayer`, `VideoMaterial`의 관계를 이해하는 데 집중합니다.

## 시작하기

실제 카메라와 ARKit이 필요하므로 iPhone 또는 iPad에서 실행합니다. Simulator에서는 카메라 기반 Image Tracking을 확인할 수 없습니다.

1. Xcode에서 프로젝트를 엽니다.
2. 실제 기기를 실행 대상으로 선택합니다.
3. 카메라 접근 권한을 허용합니다.
4. `AR Resources`에 등록된 토이스토리 포스터를 준비합니다.
5. 포스터 전체가 카메라에 보이도록 비춥니다.

## 학습 순서

- <doc:MoviePosterTutorial>
- <doc:ARKitImageTracking>
- <doc:VideoMaterial>

## 프로젝트 구성

| 파일 | 역할 |
| --- | --- |
| `Movie_PosterApp.swift` | SwiftUI 앱의 시작점 |
| `ContentView.swift` | AR 화면을 전체 화면으로 표시 |
| `ARViewContainer.swift` | SwiftUI와 RealityKit/ARKit 연결 |
| `Assets.xcassets/AR Resources` | 인식할 포스터 이미지 저장 |
| `Trailer.mov` | `AVPlayer`로 재생할 일반 Video |
