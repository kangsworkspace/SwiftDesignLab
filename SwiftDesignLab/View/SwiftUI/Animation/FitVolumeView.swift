//
//  FitVolumeView.swift
//  SwiftDesignLab
//
//  Created by 강건 on 9/7/25.
//

// MARK: - 사용된 애니메이션 소개
//
// (1) withAnimation
// - SwiftUI에서 애니메이션을 실행하는 함수
// - 상태 변화를 부드럽게 애니메이션으로 처리
// - withAnimation(.easeIn(duration: 0.6)) { volume += 1 }
//   * .easeIn: 시작은 천천히, 끝은 빠르게 (가속도가 증가하는 곡선)
//   * duration: 0.6초 동안 애니메이션 실행
//   * volume += 1: 애니메이션과 함께 실행될 상태 변화
//
// (2) transition
// - 뷰의 등장/퇴장 시 사용되는 애니메이션 효과
// - .asymmetric: 등장과 퇴장을 다르게 처리
//   * insertion: 뷰가 나타날 때의 애니메이션
//   * removal: 뷰가 사라질 때의 애니메이션
// - .opacity: 투명도 변화 (0.0 ~ 1.0)
// - .move(edge: .top): 상단 가장자리에서 이동
// - .offset(y: -40): Y축으로 -40만큼 추가 이동
// - .combined(with:): 여러 애니메이션을 동시에 적용
//


// MARK: - 애니메이션 이슈 해결 과정
//
// (1) 처음에는 아래처럼 volume 자체에 withAnimation()을 주었습니다.
// 하지만 volume이라는 값 자체에 애니메이션이 연결되었는지,
// 볼륨이 일치하는 순간 외에도 항상 숫자가 천천히 바뀌어
// 답답한 애니메이션이 연출되었습니다.
//
// Button {
//     if volume != 0 {
//         withAnimation(.easeIn(duration: 0.6)) {
//             volume -= 1
//         }
//     }
// }
//
//  (2) 그래서 아래처럼 조건에 해당할때만 애니메이션을 실행하도록 하였습니다.
//
//  Button {
//      // 10 이상을 넘는 경우 리턴 (최대 볼륨)
//      guard volume != 10 else { return }
//
//      // 1이 증가했을 떄 추천 볼륨과 일치하는 경우
//      // => 애니메이션 실행
//      guard (volume + 1) != recommendVolume else {
//          withAnimation(.easeIn(duration: 0.6)) { volume += 1 }
//          return
//      }
//
//      // 그냥 볼륨 증가
//      volume += 1
//  }
//
//  (3) 하지만 볼륨이 일치하던 상태에서 다시 일치하지 않는 상태가 될 때
//  애니메이션 처리가 되지 않아 다음과 같이 다시 분기 처리하였습니다.
//
//  Button {
//      // 10 이상을 넘는 경우 리턴 (최대 볼륨)
//      guard volume != 10 else { return }
//
//      // 1이 증가했을 떄 추천 볼륨과 일치하는 경우
//      // => 애니메이션 실행
//      guard (volume + 1) != recommendVolume else {
//          withAnimation(.easeIn(duration: 0.6)) { volume += 1 }
//          return
//      }
//
//      // 볼륨이 일치한 상태에서 증가하는 경우 일치하는 경우
//      // => 애니메이션 실행
//      guard volume != recommendVolume else {
//          withAnimation(.easeIn(duration: 0.6)) { volume += 1 }
//          return
//      }
//
//      // 그냥 볼륨 증가
//      volume += 1
//}


import SwiftUI

struct FitVolumeView: View {
    @State var volume: Int = 4
    let recommendVolume: Int = 8
    
    var isFit: Bool {
        volume == recommendVolume
    }
    
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 0) {
                    VolumeTopView(
                        volume: $volume,
                        recommendVolume: recommendVolume
                    )
                    .padding(.top, 60)
                    

                    volumeInfoView(
                        volume: volume,
                        recommendVolume: recommendVolume,
                        isFit: isFit
                    )
                    .padding(.top, 100)
                    
                    Spacer()
                }
            }
    }
}

#Preview {
    FitVolumeView()
}

private struct VolumeTopView: View {
    @Binding var volume: Int
    let recommendVolume: Int
    
    var body: some View {
        VStack {
            Text("휴대폰 볼륨을 조절 해보세요")
                .font(Font.system(size: 32, weight: .bold))
                .foregroundStyle(Color.white)
            
            HStack(spacing: 20) {
                Button {
                    // 0 이하인 경우 리턴 (최소 볼륨)
                    guard volume != 0 else { return }
                    
                    // 감소했을 떄 추천 볼륨과 일치하는 경우 일치하는 경우
                    // => 애니메이션 실행
                    guard (volume - 1) != recommendVolume else {
                        withAnimation(.easeIn(duration: 0.6)) { volume -= 1 }
                        return
                    }
                    
                    // 볼륨이 일치한 상태에서 감소하는 경우 일치하는 경우
                    // => 애니메이션 실행
                    guard volume != recommendVolume else {
                        withAnimation(.easeIn(duration: 0.6)) { volume -= 1 }
                        return
                    }
                    
                    // 그냥 볼륨 증가
                    volume -= 1
                } label: {
                    Image(systemName: "minus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                        }
                }
                
                Button {
                    // 10 이상을 넘는 경우 리턴 (최대 볼륨)
                    guard volume != 10 else { return }
                    
                    // 1이 증가했을 떄 추천 볼륨과 일치하는 경우
                    // => 애니메이션 실행
                    guard (volume + 1) != recommendVolume else {
                        withAnimation(.easeIn(duration: 0.6)) { volume += 1 }
                        return
                    }
                    
                    // 볼륨이 일치한 상태에서 증가하는 경우 일치하는 경우
                    // => 애니메이션 실행
                    guard volume != recommendVolume else {
                        withAnimation(.easeIn(duration: 0.6)) { volume += 1 }
                        return
                    }
                    
                    // 그냥 볼륨 증가
                    volume += 1
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                        }
                }
            }
            .padding(.top, 30)
        }
    }
}

private struct volumeInfoView: View {
    let volume: Int
    let recommendVolume: Int
    let isFit: Bool
    let vertitalPadding: CGFloat = 20
    
    var body: some View {
        VStack(spacing: vertitalPadding) {
            Divider()
                .background(Color.white)
            
            HStack(alignment: .center) {
                Image(systemName: isFit ? "checkmark.seal.fill" : "speaker.fill")
                    .font(.system(size: isFit ? 20 : 26))
                    .foregroundStyle(isFit ? .blue : .white)
                
                Text(isFit ? "볼륨 세팅 완료!" : "현재 볼륨")
                    .font(Font.system(size: 20, weight: .bold))
                
                Spacer()
                
                Text("\(volume)")
                    .font(Font.system(size: 32, weight: .bold))
            }
            .foregroundStyle(Color.white)
            .padding(.horizontal, 24)
            
            
            Divider()
                .background(Color.white)
            
            if volume != recommendVolume {
                VStack(spacing: vertitalPadding) {
                    HStack(alignment: .center) {
                        Image(systemName: "speaker")
                            .font(.system(size: 26))
                        
                        Text("추천 볼륨")
                            .font(Font.system(size: 20, weight: .bold))
                        
                        
                        Spacer()
                        
                        Text("\(recommendVolume)")
                            .font(Font.system(size: 32, weight: .bold))
                    }
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal, 24)
                    
                    Divider()
                        .background(Color.white)
                }
                .transition(
                    // 등장과 퇴장을 다르게 처리해주는 애니메이션
                    .asymmetric(
                        // 뷰의 등장 시
                        insertion: AnyTransition
                        // 투명도 조절
                            .opacity
                        // 상단에서 시작
                            .combined(with: .move(edge: .top))
                        // 뷰가 -40 위치에서 시작
                            .combined(with: .offset(y: -40)),
                        // 뷰의 퇴장 시
                        removal: AnyTransition
                        // 투명도 조절
                            .opacity
                        // 상단에서 시작
                            .combined(with: .move(edge: .top))
                        // 뷰가 -40만큼 추가로 이동
                            .combined(with: .offset(y: -40))
                    ))
            }
        }
    }
}
