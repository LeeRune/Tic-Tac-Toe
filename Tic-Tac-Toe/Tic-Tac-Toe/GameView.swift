//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by 李易潤 on 2021/12/12.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            // 是nil則顯示空白
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        // 點擊手勢事件
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            // 避免電腦尚未做出反應使用者多次點擊
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            // 顯示Alert
            .alert(item: $viewModel.alertItem) { alertItem -> Alert in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame()}))
            }
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            // 依照視窗寬度分成三等份
            .frame(width: proxy.size.width / 3 - 15,
                   height: proxy.size.width / 3 - 15)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            // 在frame裡調整大小
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
