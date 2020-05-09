//
//  BallGridBeat.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/6/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View, KeyframeAnimatable {
    @State private var opacity: Double = 1
    let values: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        Circle()
            .opacity(opacity)
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.opacity = self.values[keyframe]
                }
        }
    }
}

struct BallGridBeat: View {
    private let beginTimes = [0.51, 0.55, 0.83, 0.56, 0.86, 0.0, 0.03, 0.16, 0.47] // Normalized from [0.36, 0.4, 0.68, 0.41, 0.71, -0.15, -0.12, 0.01, 0.32]
    private let durations = [0.96, 0.93, 1.19, 1.13, 1.34, 0.94, 1.2, 0.82, 1.19]
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.25, c0y: 0.1, c1x: 0.25, c1y: 1)
    private let keyTimes = [0, 0.5, 1]
    private let values = [1, 0.7, 1]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 32
        let timingFunctions = [timingFunction, timingFunction]

        return VStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<3, id: \.self) { col in
                        KeyframeAnimationController<MyCircle>(beginTime: self.beginTimes[3 * row + col],
                                                              duration: self.durations[3 * row + col],
                                                              timingFunctions: timingFunctions,
                                                              keyTimes: self.keyTimes) {
                                                                MyCircle(values: self.values,
                                                                         nextKeyframe: $0)
                        }
                    }
                }
            }
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallGridBeat_Previews: PreviewProvider {
    static var previews: some View {
        BallGridBeat()
    }
}