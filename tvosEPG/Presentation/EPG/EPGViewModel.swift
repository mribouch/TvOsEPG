//
//  EPGViewModel.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import Foundation

class EPGViewModel: ObservableObject {
    
    @Published var channels: [Channel] = []
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    let hours = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    
    private var timeStepper: CGFloat = 20
    
    func onAppear() {
        self.channels = generateChannels()
        printChannels()
    }
    
    func generateChannels() -> [Channel] {
        let titles = ["La una", "TV Info", "Sports Nation", "FastCar", "Poli Tics"]
        var channels: [Channel] = []
        
        var numChan = 1
        for title in titles {
            let channel = Channel(id: UUID(), title: title, number: numChan, programs: generatePrograms())
            channels.append(channel)
            numChan += 1
        }
        
        return channels
    }
    
    private func generatePrograms() -> [Program] {
        let startDayDate = Date().midnight
//        let midnightSince70 = startDayDate.timeIntervalSince1970
        let titles = ["romantica vida", "Manchester/Psg", "Uncatchable", "Glass",
                      "Interstellar", "The dude", "Meteo", "Your night", "Jokes on command",
                      "Wanna be rich ?", "Not really", "Unfortunate", "Care it", "Wonder woman",
                      "American dream", "Random Title", "Biohazard", "Kill it", "BMTH",
                      "Twenty Century", "Remember me", "Wall-E", "Haddock Captain"]
        
//        let program = Program(id: UUID(), title: titles.randomElement()!, startDate: startDayDate, endDate: startDayDate.addingTimeInterval(Double.random(in: 20...48) * 60))
        let program = Program(id: UUID(), title: titles.randomElement()!, startDate: startDayDate, endDate: startDayDate.addingTimeInterval(60 * 60))
        
        var programs: [Program] = []
        programs.append(program)
        
        var lastEndDate = program.endDate
        
        for _ in titles {
            let p = Program(id: UUID(), title: titles.randomElement()!, startDate: lastEndDate, endDate: lastEndDate.addingTimeInterval(Double.random(in: 45...124) * 60))
            programs.append(p)
            lastEndDate = p.endDate
        }
        
        return programs
    }
    
    func increaseTimeScale(scale: CGFloat) -> CGFloat {
        guard scale <= 780 else { return scale }
        return scale + timeStepper
    }
    
    func decreaseTimeScale(scale: CGFloat) -> CGFloat {
        guard scale >= 220 else { return scale }
        return scale - timeStepper
    }
    
    func printChannels() {
        for channel in channels {
            for program in channel.programs {
                print("\(program.title): minute since midnight: \(program.startMinuteSinceMidnight)")
            }
        }
    }
    
    func getCurrentTime() -> Int {
        Int.secondsToMinutes(sec: Int(Date.now.timeIntervalSince1970) - Int(Date.now.midnight.timeIntervalSince1970))
    }
}
