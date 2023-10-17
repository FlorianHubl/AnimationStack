//  Created by Florian Hubl on 17.10.23.

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AnimationStack: View {
    
    private let views: [AnyView]
    
    @State private var animations: [Bool]
    
    let delay: Double
    
    public init<V0: View>(opacity: Bool = true, offSetX: CGFloat = 0, offSetY: CGFloat = 100, rotation: Double = 0, scale: Double = 1, delay: Double = 0.1, animation: Animation = .spring.speed(0.7), @ViewBuilder content: @escaping () -> TupleView<(V0)>) {
        let cv = content().value
        self.views = [AnyView(cv)]
        animations = [false]
        self.opacity = opacity
        self.offSetX = offSetX
        self.offSetY = offSetY
        self.rotation = rotation
        self.scale = scale
        self.delay = delay
        self.animation = animation
    }
    
    public init<Views>(opacity: Bool = true, offSetX: CGFloat = 0, offSetY: CGFloat = 100, rotation: Double = 0, scale: Double = 1, delay: Double = 0.1, animation: Animation = .spring.speed(0.7), @ViewBuilder content: @escaping () -> TupleView<Views>) {
        views = content().getViews
        var bools = [Bool]()
        if views.count == 0 {
            bools.append(false)
        }else {
            for _ in views {
                bools.append(false)
            }
        }
        self.animations = bools
        self.opacity = opacity
        self.offSetX = offSetX
        self.offSetY = offSetY
        self.rotation = rotation
        self.scale = scale
        self.delay = delay
        self.animation = animation
    }
    
    @State private var index = 0
    
    let opacity: Bool
    let offSetY: CGFloat
    let offSetX: CGFloat
    let rotation: Double
    let scale: Double
    let animation: Animation
    
    private func start() {
        guard index < animations.count else {return}
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            animations[index] = true
            index += 1
            start()
        }
    }
    
    public var body: some View {
        ForEach(views.indices, id: \.self) { i in
            views[i]
                .opacity(animations[i] ? 1 : self.opacity ? 0 : 1)
                .offset(y: animations[i] ? 1 : offSetY)
                .offset(x: animations[i] ? 0 : offSetX)
                .scaleEffect(animations[i] ? 1 : scale)
                .rotationEffect(Angle(degrees: animations[i] ? 0 : rotation))
        }
        .animation(animation, value: animations)
        .onAppear(perform: start)
    }
}
