# Movie Poster 튜토리얼 시각 자료 교체 목록

현재 `MoviePosterDocumentation.docc/Resources`의 `xc-*.svg`와 `08-*.svg`는 Xcode·iPhone 화면을 설명하기 위한 안내 그림입니다. Xcode 버전, macOS 테마, 창 크기, 기기 모델이 고정되지 않은 상태에서는 SVG를 실제 화면과 완전히 동일하다고 보장할 수 없습니다. 최종 배포 전에 아래 실제 캡처로 교체하세요.

## 캡처 기준

- 튜토리얼에 사용할 Xcode 버전과 macOS 버전을 캡처에 맞춥니다.
- 문서의 예시 이름 `Movie Poster`, `AR Resources`, `토이스토리 포스터.jpeg`, `토이스토리.mov`, Width `0.21 m`를 그대로 사용합니다.
- Xcode 화면은 전체 창이 보이게 캡처하고, 해당 단계에서 눌러야 하는 메뉴·행·값이 읽히도록 오른쪽 인스펙터와 프로젝트 내비게이터를 포함합니다.
- 실행 결과는 Simulator가 아니라 실제 ARKit 지원 iPhone 또는 iPad에서 캡처합니다.
- 개인정보, Apple ID 이메일, 기기 일련번호는 캡처 전에 가립니다.

## 필요한 파일

| 파일명 | 촬영 화면 | 교체할 안내 자료 |
| --- | --- | --- |
| `capture-01-project-template.png` | 새 프로젝트에서 iOS > App, SwiftUI, Swift가 선택된 화면 | `xc-new-project-template.svg` |
| `capture-02-signing.png` | Target > Signing & Capabilities의 Team과 자동 서명 | `xc-signing-capabilities.svg` |
| `capture-03-video-target-membership.png` | 영상 파일의 File Inspector > Target Membership | `xc-drag-video-file.svg` |
| `capture-04-ar-resources.png` | Assets.xcassets 안의 AR Resources와 포스터 | `xc-assets-new-ar-group.svg`, `xc-assets-drag-poster.svg` |
| `capture-05-physical-size.png` | 포스터 File Inspector의 Physical Size > Width/Height | `xc-file-inspector-width.svg` |
| `capture-06-camera-permission.png` | Target > Info의 Privacy - Camera Usage Description | `xc-info-camera-usage.svg` |
| `capture-07-device-run.png` | Xcode 실행 대상 메뉴에서 연결된 실제 기기 선택 | `xc-run-destination.svg` |
| `capture-08-recognition.png` | 실제 기기 카메라에 포스터 전체와 AR 포털이 함께 보이는 화면 | `08-poster-framing.svg`, `08-device-test.svg` |
| `capture-09-console-log.png` | Xcode 콘솔의 `포스터 인식 완료:` 로그 | `xc-console-log.svg` |
| `capture-10-final-portal.png` | 최종 포털과 영상이 재생되는 실제 기기 화면 | `toy-story-poster.jpeg` 또는 최종 결과 안내 자료 |

캡처를 받은 뒤에는 파일명과 문서의 `@Image(source:)`를 일대일로 바꾸고, 각 이미지의 설명도 실제 캡처에서 보이는 Xcode 버전·기기와 일치하도록 다시 작성해야 합니다.
