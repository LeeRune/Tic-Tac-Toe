//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by 李易潤 on 2021/12/12.
//

import SwiftUI

class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    // 判斷是否可以點擊
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) {return}
        // 註記哪個index被點擊
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        // 電腦延遲0.5秒做出反應
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = computerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    // 判斷區塊是否被點擊過
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    // 判斷電腦可以在哪個區塊動作
    func computerMovePosition(in moves: [Move?]) -> Int {
        
        // 電腦判斷邏輯
        // 1. 如果電腦選定的位置有機會贏，則在連線上再選定一個位置
        // 獲勝組合
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        // 過濾陣列中值為nil
        let computerMoves = moves.compactMap {$0}.filter { $0.player == .computer }
        // 重新建立電腦選擇過的組合
        let computerPosition = Set(computerMoves.map {$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        // 2. 如果玩家選定的位置有機會贏，則阻擋玩家連線
        // 過濾陣列中值為nil
        let humanMoves = moves.compactMap {$0}.filter { $0.player == .human }
        // 重新建立玩家選擇過的組合
        let humanPosition = Set(humanMoves.map {$0.boardIndex})
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        
        // 3. 如果正中間沒有被選擇，則選定中間位置
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // 4. 如果沒有機會連線或不需要阻擋玩家連線，則隨機選擇位置
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    // 判斷是否獲勝
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        
        // 獲勝組合
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        // 過濾陣列中值為nil
        let playerMoves = moves.compactMap {$0}.filter { $0.player == player }
        
        // 重新建立玩家選擇過的組合
        let playerPosition = Set(playerMoves.map {$0.boardIndex})
        
        // 判斷playerPosition是否有在winPatterns內
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {return true}
        
        return false
    }
    
    // 判斷是否和局
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    // 重製陣列
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
