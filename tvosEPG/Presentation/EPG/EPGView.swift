//
//  EPGView.swift
//  tvsandbox
//
//  Created by Martin Ribouchon on 10/03/2023.
//

import SwiftUI

struct EPGView: View {
//    @FocusState var isFocused
    @ObservedObject var viewModel: EPGViewModel
    @State private var hourSize: CGFloat = 400
    @State private var currentTime: Int = Int.secondsToMinutes(sec: Int(Date.now.timeIntervalSince1970) - Int(Date.now.midnight.timeIntervalSince1970))
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            contentView
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            
        }
        .onAppear(perform: onAppear)
    }
    
    /// Just the button to resize the timeline
    var scaleButtons: some View {
        HStack {
            Text("-")
                .font(.system(size: 45))
                .modifier(FocusModifier())
                .onTapGesture {
                    withAnimation {
                        hourSize = viewModel.decreaseTimeScale(scale: hourSize)
                    }
                }
            Text("+")
                .font(.system(size: 45))
                .modifier(FocusModifier())
                .onTapGesture {
                    withAnimation {
                        hourSize = viewModel.increaseTimeScale(scale: hourSize)
                    }
                }
        }
    }
    
    /// Here is the trick, we are adding to the channels another view (the scales button) in order to have
    /// the timeline perfectly align with it (Other wise it would have align horizontally 5 channels with 5 programs and a timeline
    /// so 5 views with 6 views, which would lead into a big shifting between them)
    func makeChannels() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            scaleButtons
                .frame(width: .epgChannelHeight, height: .epgChannelHeight, alignment: .bottom)
                .ignoresSafeArea()
            
            ForEach(viewModel.channels, id: \.self.id) { channel in
                VStack {
                    Image(systemName: "circle")
                    Text(channel.title)
//                        .multilineTextAlignment(.leading)
                }
                .modifier(FocusModifier())
                .frame(width: .epgChannelHeight, height: .epgChannelHeight)
                .background(RoundedRectangle(cornerRadius: .epgChannelCornerRadius).stroke(lineWidth: .epgChannelLineWidth).background(.gray))
                .ignoresSafeArea()
            }
        }
    }
    
    /// we're using a ZStack to prevent the size and spacing issues that we could encounter with a HStack
    /// we only need to calculate the correct offset and it's done
    var timeline: some View {
        ZStack(alignment: .leading) {
            ForEach(Array(viewModel.hours.enumerated()), id: \.element) { i, hour in
                HStack(alignment: .bottom, spacing: .timelineSpacing) {
                    Rectangle()
                        .frame(width: .timelineSegmentWidth, height: .timelineSegmentHeight)
                    Text(hour)
                        .foregroundColor(.orange)
                }
                .frame(alignment: .bottom)
                .offset(x: hourSize * CGFloat(i) - .timelineSegmentWidth / 2)
            }
        }
        .frame(width: hourSize * 24, height: .epgChannelHeight, alignment: .bottomLeading)
    }
    
    /// The program view
    func makeProgram(program: Program) -> some View {
        VStack {
            Text(program.title)
                .font(.system(size: 35, design: .rounded))
                .padding(.top, .programTitlePaddingTop)
            Spacer()
            HStack {
                Text(program.startDate.formatted(date: .omitted, time: .shortened))
                Spacer()
                Text(program.endDate.formatted(date: .omitted, time: .shortened))
            }
            .padding(.horizontal, .programHoursPaddingHorizontal)
            .padding(.vertical, .programHoursPaddingVertical)
        }
    }
    
    /// We're using a ZStack to be able to place the programs at the correct position according to the timeline
    /// The day start at midnight so we can use the minutes number that passed between midnight and the start of the program
    /// and calculate the exact position of the program from it using the hourSize State variable
    func makeProgramsChannel(channel: Channel) -> some View {
        ZStack(alignment: .leading) {
            ForEach(channel.programs, id: \.self.id) { program in
                makeProgram(program: program)
                    .frame(width: CGFloat(Int.secondsToMinutes(sec: program.duration)) * (hourSize / 60), height: .epgChannelHeight)
                    .modifier(ProgramModifier(hasBegun: program.programHasBegun()))
                    .offset(x: CGFloat(program.startMinuteSinceMidnight) * (hourSize / 60))
            }
        }
    }
    
    var currentTimeSegment: some View {
        Rectangle()
            .fill(.orange.opacity(0.7))
            .frame(maxWidth: .ctsWidth, maxHeight: (CGFloat(viewModel.channels.count)) * .epgChannelHeight + .timelineSegmentHeight , alignment: .leading)
            .offset(x: CGFloat(currentTime) * (hourSize / 60) - .ctsWidth / 2)
            .onReceive(viewModel.timer) { _ in
                currentTime = viewModel.getCurrentTime()
            }
    }
    
    var contentView: some View {
        HStack(spacing: 0) {
            makeChannels()
            ScrollView(.horizontal) {
                ZStack(alignment: .bottomLeading) {
                    VStack( alignment: .leading, spacing: 0) {
                        timeline
                        ForEach(viewModel.channels, id: \.self.id) { channel in
                            makeProgramsChannel(channel: channel)
                                .frame(alignment: .leading)
                        }
                    }
                    currentTimeSegment
                }
            }
        }
    }
    
}

extension EPGView {
    func onAppear() {
        viewModel.onAppear()
    }
}

struct EPGView_Previews: PreviewProvider {
    static var previews: some View {
        EPGConfigurator.configureEPGView()
    }
}
