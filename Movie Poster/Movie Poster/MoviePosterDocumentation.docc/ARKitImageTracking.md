# ARKit Image Tracking

## 이미지 추적의 핵심 개념

Image Tracking은 카메라가 특정 2D 이미지를 찾고, 이미지의 위치와 방향을 계속 추적하는 기능입니다.

### 주요 객체

- `ARReferenceImage`: 미리 등록한 참조 포스터입니다.
- `ARImageTrackingConfiguration`: 추적할 이미지를 설정합니다.
- `ARSession`: 카메라 프레임과 추적 결과를 관리합니다.
- `ARImageAnchor`: 실제 공간에서 발견된 포스터의 위치와 방향입니다.
- `AnchorEntity`: ARImageAnchor에 붙어 움직이는 RealityKit 컨테이너입니다.

### 문제 해결

- Simulator가 아닌 실제 기기에서 실행합니다.
- 포스터 전체가 카메라에 보이는지 확인합니다.
- 참조 이미지의 실제 물리적 너비가 설정되어 있는지 확인합니다.
- 카메라 권한을 허용했는지 확인합니다.
- `AR Resources` 그룹 이름이 코드와 같은지 확인합니다.
