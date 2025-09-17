// MARK: - 사용된 UI 요소 소개
//
//
// (1) mask
// - 주어진 뷰로 해당 뷰를 마스킹하는 메서드
// - 뷰에 mask를 적용하면 일단 모든 영역을 가리고, mask 영역만 표시
// - .mask { Rectangle().frame(width: dragOffset) }: dragOffset만큼의 너비만 보이게 함
// - 슬라이드 진행률에 따라 초록색 배경이 점진적으로 나타나는 효과 구현
//
// (2) DragGesture
// - 드래그 제스처를 받도록 처리
// - .onChanged: 드래그 중 실시간으로 호출되는 콜백
// - value.translation.width: 사용자가 드래그한 수평 거리
// - max(0, min(maxOffset, value.translation.width)): 드래그 범위를 0~최대값으로 제한
// - .onEnded: 드래그가 끝났을 때 호출되는 콜백
// - 완료 조건 검사 후 애니메이션으로 완료 또는 리셋 처리
//
// (3) withAnimation
// - SwiftUI에서 상태 변화를 부드럽게 애니메이션으로 처리하는 함수
// - .spring : 스프링 애니메이션
// - response: 애니메이션의 지속 시간
// - dampingFraction: 얼마나 흔들릴지


// MARK: - 애니메이션 이슈 해결 과정
//
// (1) 버튼이 과하게 튀어나가는 문제
// 문제: .onEnded의 완료 애니메이션 처리도 동적이게 spring으로 하였습니다.
// 하지만 엄청 빠르게 옆으로 넘기면 버튼이 과도하게 튀어나가는 문제가 발생하였습니다.
//
// 해결: easeOut으로 변경하였습니다.
//
//
// (2) 햅틱 피드백 이슈
// 문제: 처음에는 정확히 결제 완료 경계 지점에 도달했을 때만 햅틱을 주었습니다. ( offset == completeWidth )
// 하지만 사용자가 빠르게 드래그하면 80% 지점을 건너뛰어서 햅틱이 발생하지 않았습니다.
//
// 해결: 이전 위치(previousOffset)와 현재 위치(newOffset)를 비교해서,
// 결제 완료 경계 지점이 두 위치 사이에 있는지 확인하는 방식으로 변경하였습니다.
// 빠른 드래그에서도 햅틱을 발생하도록 하였습니다.
//
//
// (3) 햅틱 최초 실행 시 렉걸림
// 문제: 앱을 처음 실행하고 햅틱 지점에 가면 항상 렉이 걸렸습니다.
//
// 해결: 렉이 걸릴때 마다 콘솔에 App is being debugged, do not track this hang, Hang detected: 0.36s 같은 로그가 떴고,
// 렉이 걸리는 시간과 비슷해서 찾아보니 디버그 모드에서 모든 동작을 추적하기 때문에 렉이 걸릴 수 있었습니다.
// 스킴 편집에서 릴리즈 모드로 변경, Debug executable을 체크해제하니 렉이 사라졌습니다.


import SwiftUI

struct SlidePayView: View {
    // 슬라이드 한 값을 받아오는 객체
    @State private var dragOffset: CGFloat = 0
    // 결제가 완료되었는지 여부
    @State private var isCompleted = false
    
    // 완료 판정 비율
    private let completeRatio: CGFloat = 0.86
    // 피드백을 주는 객체
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    private let buttonText: String = "밀어서 결제하기"
    private let buttonWidth: CGFloat = 340
    private let buttonHeight: CGFloat = 48
    private let handleSize: CGFloat = 50
    
    // 최대 이동 거리
    private var maxOffset: CGFloat { buttonWidth - handleSize }
    // 완료 판정 거리
    private var completeWidth: CGFloat { maxOffset * completeRatio }
    
    var body: some View {
        VStack {
            Text("밀어서 결제하기 버튼")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            Button {
                // 0으로 되돌리기
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    dragOffset = 0
                    isCompleted = false
                }
            } label: {
                Text("리셋 버튼")
                    .font(.system(size: 16)).bold()
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .tint(Color.green.opacity(0.6))
            .disabled(!isCompleted)
            
            Text(isCompleted ? "🤩" : "🫩")
                .font(.system(size: 160))
            
            Text(isCompleted ? "☕️" : " ")
                .font(.system(size: 100))
            
            Spacer()
            
            // 슬라이드 버튼
            ZStack {
                // 슬라이드 전 보이는 배경 캡슐
                Capsule()
                    .fill(Color.gray.opacity(0.12))
                
                // 슬라이드 전 보이는 기본 텍스트
                Text(buttonText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.7))
                
                // 슬라이드 했을 때 보이는 배경과 텍스트
                ZStack {
                    Capsule()
                        .fill(Color.green)
                    
                    Text(buttonText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .mask {
                    HStack {
                        Rectangle()
                        // 최소값 0
                            .frame(width: max(0, dragOffset + (handleSize / 2)))
                        
                        Spacer()
                    }
                }
                
                // 슬라이드 - 드래그 제스쳐를 받을 버튼
                HStack {
                    Circle()
                        .frame(width: handleSize, height: handleSize)
                        .overlay {
                            Image(systemName: "chevron.right")
                                .font(.title2).fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                        }
                        .offset(x: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard !isCompleted else { return }
                                    
                                    // 이전 위치
                                    let previousOffset = dragOffset
                                    
                                    // 새로운 위치
                                    let newOffset = max(0, min(maxOffset, value.translation.width))
                                    
                                    // 결제 완료 지점을 위로 넘었는지 계산
                                    // (이전에 넘지 않았고, 지금 넘은 상태의 조건)
                                    let wasBelow = previousOffset < completeWidth
                                    let isAbove = newOffset >= completeWidth
                                    let crossedUp = wasBelow && isAbove
                                    
                                    // 결제 완료 지점을 아래로 넘었는지 계산
                                    // (이전에 넘었고, 지금 넘지 않은 상태의 조건)
                                    let wasAbove = previousOffset >= completeWidth
                                    let isBelow = newOffset < completeWidth
                                    let crossedDown = wasAbove && isBelow
                                    
                                    if crossedUp || crossedDown {
                                        impactFeedback.impactOccurred()
                                    }
                                    
                                    // 위치 업데이트
                                    dragOffset = newOffset
                                }
                                .onEnded { _ in
                                    if !isCompleted {
                                        let maxOffset = buttonWidth - handleSize
                                        let completeWidth = maxOffset * completeRatio
                                        
                                        if dragOffset >= completeWidth {
                                            // 완료 처리
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                dragOffset = maxOffset
                                                isCompleted = true
                                            }
                                            
                                        } else {
                                            // 0으로 되돌리기
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                dragOffset = 0
                                                isCompleted = false
                                            }
                                        }
                                    }
                                }
                        )
                    
                    Spacer()
                }
            }
            .frame(width: buttonWidth, height: buttonHeight)
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    SlidePayView()
}
