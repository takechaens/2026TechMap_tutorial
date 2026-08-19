# Movie Poster ARKit DocC Tutorial

영화 포스터를 인식하면 포스터 안쪽에 깊이감 있는 영화관 포털과 일반 Video 예고편을 표시하는 ARKit 학습 프로젝트입니다.

## 문서 보기

Xcode에서 프로젝트를 연 뒤 **Product > Build Documentation**을 실행합니다. DocC 카탈로그는 다음 경로에 있습니다.

`Movie Poster/MoviePosterDocumentation.docc`

## GitHub Pages 배포

저장소의 GitHub Pages 설정에서 **Source**를 **GitHub Actions**로 선택합니다. 이후 `main` 브랜치에 push하면 `.github/workflows/deploy-docs.yml`이 DocC archive를 정적 사이트로 변환해 배포합니다.

## 실행 조건

- 카메라가 있는 실제 iPhone 또는 iPad
- 카메라 권한 허용
- `AR Resources`에 등록된 토이스토리 포스터
- 앱 번들에 포함된 `Trailer.mov`

이 튜토리얼은 Spatial Video가 아닌 일반 Video를 사용하며, ARKit Image Tracking의 기초와 RealityKit 콘텐츠 배치를 학습하는 데 초점을 둡니다.
