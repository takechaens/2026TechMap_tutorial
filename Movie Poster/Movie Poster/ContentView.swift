import SwiftUI

struct ContentView: View {
    var body: some View {
        // 방금 만든 AR 화면 포장지를 불러옵니다.
        // 화면 전체를 꽉 채우도록 설정합니다.
        ARViewContainer()
            .ignoresSafeArea()
    }
}
