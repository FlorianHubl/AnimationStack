//  Created by Florian Hubl on 17.10.23.

import SwiftUI

@available(iOS 14.0, macOS 11, tvOS 13.0, watchOS 6.0, *)
public struct ForEachAnimation<Data, Content>: View where Data : Hashable, Content : View {
    let data: [Data]
    private let content: (Data) -> Content
    
    public init(_ data: [Data], opacity: Bool = true, offSetX: CGFloat = 0, offSetY: CGFloat = 0, rotation: Double = 0, scale: Double = 1, delay: Double = 0.1, animation: Animation = .spring.speed(0.7), @ViewBuilder content: @escaping (Data) -> Content) {
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
    
    public init(_ data: [Data], @ViewBuilder content: @escaping (Data) -> Content) {
        self.data = data
        self.content = content
        self.opacity = true
        self.offSetX = 0
        self.offSetY = 100
        self.rotation = 0
        self.scale = 1
        self.delay = 0.1
        self.animation = .spring.speed(0.7)
        self.animations = Array(repeating: false, count: 100)
    }
    
    @State private var animations: [Bool]
    
    private func start() {
        guard index < data.count else {
            var ary = Array(repeating: true, count: data.count)
            ary.append(contentsOf: Array(repeating: false, count: 100))
            self.animations = ary
            return
        }
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
                    .transition(.opacity)
            }
            .animation(animation, value: animations)
            .animation(animation, value: data)
            .onAppear(perform: start)
            .onChange(of: data) { oldValue, newValue in
                guard newValue.count != oldValue.count else {return}
                if newValue.count > oldValue.count {
                    index = oldValue.count
                    start()
                }else {
                    index = oldValue.count
                    var ary = Array(repeating: true, count: newValue.count)
                    ary.append(contentsOf: Array(repeating: false, count: 100))
                    self.animations = ary
                }
            }
        }
    }
}
