//  Created by Florian Hubl on 17.10.23.

import SwiftUI

@available(iOS 14.0, macOS 11, tvOS 13.0, watchOS 6.0, *)
public struct ForEachAnimation<Data, Content>: View where Data : Hashable, Content : View {
    let data: [Data]
    private let content: (Data) -> Content
    
    public init(_ data: [Data], opacity: Bool = true, offSetX: CGFloat = 0, offSetY: CGFloat = 100, rotation: Double = 0, scale: Double = 1, delay: Double = 0.1, animation: Animation = .spring.speed(0.7), @ViewBuilder content: @escaping (Data) -> Content) {
        self.data = data
        self.content = content
        self.opacity = opacity
        self.offSetX = offSetX
        self.offSetY = offSetY
        self.rotation = rotation
        self.scale = scale
        self.delay = delay
        self.animation = animation
        self.animations = Array(repeating: false, count: 10)
    }
    
    @State private var animations: [Bool]
    
    private func start() {
        guard index < data.count else {return}
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            animations[index] = true
            index += 1
            start()
        }
    }
    
    @State private var index = 0
    
    let opacity: Bool
    let offSetY: CGFloat
    let offSetX: CGFloat
    let rotation: Double
    let scale: Double
    let delay: Double
    let animation: Animation
    
    public var body: some View {
        return Group {
            ForEach(data.indices, id: \.self) { i in
                content(data[i])
                    .opacity(animations[i] ? 1 : self.opacity ? 0 : 1)
                    .offset(y: animations[i] ? 1 : offSetY)
                    .offset(x: animations[i] ? 0 : offSetX)
                    .scaleEffect(animations[i] ? 1 : scale)
                    .rotationEffect(Angle(degrees: animations[i] ? 0 : rotation))
            }
            .animation(animation, value: animations)
            .animation(animation, value: data)
            .onAppear(perform: start)
            .onChange(of: data) { newValue in
                var newBools = Array(repeating: true, count: newValue.count)
                newBools.append(contentsOf: Array(repeating: false, count: 100))
                self.animations = newBools
            }
        }
    }
}
