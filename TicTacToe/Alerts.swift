//
//  Alerts.swift
//  TicTacToe
//
//  Created by Ömer ALOĞLU on 29.04.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    let humanWin = AlertItem(title: Text("You Win"),
                             message: Text("You are so smart. you beat your own AI"),
                             buttonTitle: Text("Hell yeah"))
    
    let computerWin = AlertItem(title: Text("You Lost"),
                             message: Text("You programmed a super AI"),
                             buttonTitle: Text("Rematch"))
    
    let draw = AlertItem(title: Text("Draw"),
                             message: Text("What a battle of wins we have here..."),
                             buttonTitle: Text("Try again"))
    
}

