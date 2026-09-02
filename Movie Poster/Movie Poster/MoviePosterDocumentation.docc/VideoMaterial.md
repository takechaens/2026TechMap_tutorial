# VideoMaterial

## 영상 재생 구조

```text
토이스토리.mov
    ↓
AVPlayer
    ↓
VideoMaterial
    ↓
ModelEntity
```

`AVPlayer`는 영상을 읽고 재생합니다. `VideoMaterial`은 AVPlayer의 현재 프레임을 RealityKit 3D 표면의 재질로 표시합니다.

이 프로젝트는 Spatial Video가 아니라 일반 2D Video를 사용합니다. Image Tracking과 3D 배치 원리를 먼저 이해하기 위한 선택입니다.
