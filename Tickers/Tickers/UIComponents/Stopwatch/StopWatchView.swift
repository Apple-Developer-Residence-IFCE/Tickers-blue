import SwiftUI
import Combine


enum PomodoroState {
    case work
    case breakTime
    case pause
}

struct StopWatchView: View {
    @ObservedObject var viewModel: PomodoroViewModel
    
    @State private var currentState: PomodoroState = .work
    @State private var isTimerRunning = false
    @State private var isBreakTimeStarted = false // Verificar se o tempo de descanso já iniciou
    @Binding var restTime: Bool
    
    var body: some View {
        VStack {
            ZStack {
                CircularProgressView(progress: progress)
                VStack(spacing: 20) {
                    Text("\(viewModel.minutes()):\(viewModel.seconds())")
                        .foregroundColor(Color("blueColorPrimary"))
                        .font(.system(size: 45, weight: .medium))
                        .bold().padding(.top, 40)
                    HStack {
                        Button {
                            resetTimer()
                        } label: {
                            Image("ButtonReiniciar")
                        }.padding(10)
                        Button {
                            if !isTimerRunning {
                                startTimer()
                            } else {
                                stopTimer()
                            }
                        } label: {
                            if isTimerRunning {
                                Image("ButtonPause")
                                    .padding(.bottom, 10)
                            } else {
                                Image("ButtonPlayStopWatch")
                                    .padding(.bottom, 10)
                            }
                        }.padding(10)
                        Button {
                            skipBreak()
                        } label: {
                            Image("ButtonNext")
                        }.padding(10)
//                            .disabled(currentState != .breakTime)
                        
                    }
                }
            }.frame(width: 240, height: 240)
        }
        .onReceive(
            viewModel.timer
        ) { _ in
            
            
            if isTimerRunning && viewModel.timeRemaining > 0 {
                viewModel.timeRemaining -= 1
                if viewModel.timeRemaining <= 0 {
                    timerComplete()
                }
            }
        }
        .onChange(of: currentState) { newValue in
            if newValue == .work || newValue == .breakTime {
                isTimerRunning = true
            } else {
                isTimerRunning = false
            }
        }
    }
    
    var progress: Double {
        Double(viewModel.timeRemaining) / Double(25 * 60)
    }
    
    func resetTimer() {
        currentState = .work
        viewModel.timeRemaining = 25 * 60
        isBreakTimeStarted = false
        restTime = false
    }
    
    func startTimer() {
        if viewModel.timeRemaining <= 0 {
            timerComplete()
        } else {
            currentState = .work
            isTimerRunning = true
        }
    }
    
    func stopTimer() {
        currentState = .pause
        isTimerRunning = false
    }
    
    func skipBreak() {
        if currentState == .breakTime {
            currentState = .work
            viewModel.timeRemaining = 25 * 60
            isBreakTimeStarted = false
            restTime = false
            isTimerRunning = true
        } else if currentState == .work && !isBreakTimeStarted {
            currentState = .breakTime
            viewModel.timeRemaining = 5 * 60
            isBreakTimeStarted = true
            restTime = true
            isTimerRunning = true
        }
    }

    func timerComplete() {
        if currentState == .work {
            currentState = .breakTime
            viewModel.timeRemaining = 5 * 60
            isBreakTimeStarted = true
            restTime = true
        } else if currentState == .breakTime {
            currentState = .work
            viewModel.timeRemaining = 25 * 60
            isBreakTimeStarted = false
            restTime = false
        }
    }
}



struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView(viewModel: PomodoroViewModel(), restTime: .constant(true))
    }
}
