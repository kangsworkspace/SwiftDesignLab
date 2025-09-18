// MARK: - 사용된 UI 요소 소개
//
// isBlinking 값을 통해 뷰의 opacity의 변화를 주며 깜빡이는 애니메이션을 구현했습니다.
// StartView는 onAppear 시점에 startBlinking() 함수를 실행하는데,
// startBlinking()는 withAnimation으로 isBlinking의 값을 변화시킵니다.
//
// 별들의 위치나, 깜빡이는 정도 등등 최대한 랜덤하게 나타내려 했는데,
// 애니메이션도 랜덤으로 넣으면 어떨까하는 생각이 문득 들어 애니메이션도 랜덤으로 넣었습니다.
// (티는 별로 안나네요)
//
//
// (1) withAnimation
// - .easeInOut: 시작과 끝 부분을 천천히, 중간은 빠르게
// - .easeIn: 시작을 천천히, 끝은 빠르게
// - .easeOut: 시작을 빠르게, 끝은 천천히
// - .linear: 일정한 속도로 애니메이션 실행
// - .repeatForever(autoreverses: true): 무한 반복 + autoreverse로 애니메이션 역재생
// - .speed(1.0 / animationDuration) : 애니메이션의 재생 속도를 조절하는 메서드 (1.0의 값을 기준으로 속도 조절)
//  (예시)
//  animationDuration = 3.0
//  speed(1.0 / 3.0) = speed(0.33)
//  결과: 1.0초 / 0.33 = 3.0초 (0.33배 느리게 => 3초 근처)


// MARK: - 애니메이션 이슈 해결 과정
//
// (1) 별들의 색상 자주 변경시 불편함
// 문제: 처음에는 enum으로 별들의 색상을 관리하였는데,
// 어울리는 색을 찾으며 수정하다보니 불편했습니다.
//
// 해결: 색상 배열을 파라미터로 받아서 랜덤으로 선택하는 함수로 변경



import SwiftUI

struct BlinkStarView: View {
    @State private var stars: [StarData] = []
    
    // 별 갯수
    let starCount: Int = 60
    
    // 별 색상 배열
    let starColors: [Color] = [.white, .mint]
    
    // 별 애니메이션 배열
    let starAnimations: [Animation] = [
        .easeInOut,
        .easeIn,
        .easeOut,
        .linear,
    ]
    
    // 별 크기의 범위
    let starSizeRange: ClosedRange<Double> = 1...18
    
    // 별 투명도 범위
    let starOpacityRange: ClosedRange<Double> = 0.1...0.5
    
    // 별 반짝이는 속도 범위
    let starDurationRange: ClosedRange<Double> = 2.0...5.0
    
    // 별이 깜빡이는 정도
    let starBlinkOpacity: ClosedRange<Double> = 0.1...0.3
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ForEach(stars, id: \.id) { star in
                StarView(
                    color: star.color,
                    size: star.size,
                    opacity: star.opacity,
                    animation: star.animation,
                    animationDuration: star.animationDuration,
                    blinkOpacity: star.blinkOpacity
                )
                .position(star.position)
            }
            
            VStack {
                Text("별멍을 때려보아요")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 28)).bold()
            }
        }
        .onAppear {
            generateRandomStars(
                count: starCount,
                colors: starColors,
                animations: starAnimations,
                sizeRange: starSizeRange,
                opacityRange: starOpacityRange,
                durationRange: starDurationRange,
                blinkOpacity: starBlinkOpacity,
            )
        }
    }
    
    // 별 데이터를 생성하는 함수
    private func generateRandomStars(
        count: Int,
        colors: [Color],
        animations: [Animation],
        sizeRange: ClosedRange<Double>,
        opacityRange: ClosedRange<Double>,
        durationRange: ClosedRange<Double>,
        blinkOpacity: ClosedRange<Double>,
    ) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        stars = (0..<count).map { _ in
            StarData(
                color: getRandomColor(from: colors),
                animation: getRandomAnimation(from: animations),
                size: Double.random(in: sizeRange),
                opacity: Double.random(in: opacityRange),
                animationDuration: Double.random(in: durationRange),
                position: CGPoint(
                    x: Double.random(in: 0...screenWidth),
                    y: Double.random(in: 0...screenHeight)
                ),
                blinkOpacity: Double.random(in: blinkOpacity)
            )
        }
    }
    
    // 랜덤 색상 가져오기
    private func getRandomColor(from colors: [Color]) -> Color {
        return colors.randomElement() ?? .yellow
    }
    
    // 랜덤 애니메이션 가져오기
    private func getRandomAnimation(from animations: [Animation]) -> Animation {
        return animations.randomElement() ?? .easeInOut
    }
}

#Preview {
    BlinkStarView()
}


private struct StarView: View {
    let color: Color
    let size: Double
    let opacity: Double
    let animation: Animation
    let animationDuration: Double
    let blinkOpacity: Double
    
    @State private var isBlinking = false
    
    var body: some View {
        Circle()
            .foregroundStyle(color.opacity(isBlinking ? opacity : opacity * blinkOpacity))
            .frame(width: size, height: size)
            .onAppear {
                startBlinking()
            }
    }
    
    private func startBlinking() {
        withAnimation(
            animation.speed(1.0 / animationDuration)
            .repeatForever(autoreverses: true)
        ) {
            isBlinking = true
        }
    }
}

private struct StarData: Identifiable {
    let id = UUID()
    let color: Color
    let animation: Animation
    let size: Double
    let opacity: Double
    let animationDuration: Double
    let position: CGPoint
    let blinkOpacity: Double
}
