//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by 李易潤 on 2021/12/12.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("恭喜！"), message: Text("你獲勝了！"), buttonTitle: Text("再來一局！"))
    static let computerWin = AlertItem(title: Text("可惜！"), message: Text("你輸了！"), buttonTitle: Text("再來一局！"))
    static let draw = AlertItem(title: Text("恭喜！"), message: Text("和局！"), buttonTitle: Text("再來一局！"))
}


