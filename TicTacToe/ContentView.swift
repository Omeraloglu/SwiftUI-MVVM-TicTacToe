//
//  ContentView.swift
//  TicTacToe
//
//  Created by Ömer ALOĞLU on 29.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 15){
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            isGameboardDisabled = true
                            
                            if checkWinCodition(for: .human, in: moves){
                                print("Human wins")
                                return
                            }
                            
                            if checkForDraw(in: moves){
                                print("draw")
                                return
                            }
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPosition = determinComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisabled  = false
                                
                                if checkWinCodition(for: .computer, in: moves){
                                    print("Computer wins")
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    print("draw")
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {resetGame()}))
            })
        }
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determinComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCodition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame () {
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player{
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
