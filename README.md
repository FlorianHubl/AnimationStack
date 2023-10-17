# AnimationStack

A Stack which animates the Views inside it. Create animated ForEach Loops with ForEachAnimation. You can also customise the animation.

<img src="https://github.com/FlorianHubl/AnimationStack/blob/main/Animation1.gif">

## Documentation

### Creating Animation Stack

```swift
VStack {
    AnimationStack {
            Text("Welcome")
            Text("to")
            Text("AnimationStack")
        }
    }
.bold()
.font(.largeTitle)
```

### Customise AnimationStack

```swift
AnimationStack(opacity: true, offSetX: 100, offSetY: 100, rotation: 11, scale: 2, delay: 0.3, animation: .spring.speed(0.7)) {
    Text("Welcome")
    Text("to")
    Text("AnimationStack")
}
```

All the provided parameters are the values before the animation starts.

### Example

opacity: true
offSetX: 100
delay: 1

The Stack will blend in the views because opacity is true.
The Stack will animate the offset of the views from 100 to 0.

The delay is the time between the animation of the views. When you have three views in the Stack and the delay is one then the first view will animate in 1 second, the second one in 2 seconds and the thrid one in three seconds.

```swift
HStack {
    AnimationStack(opacity: true, offSetX: 100, offSetY: 0, delay: 1) {
        Text("Amazing")
        Text("Wow")
        Text("Cool")
        Text("Nice")
    }
}
.bold()
.font(.largeTitle)
```

<img src="https://github.com/FlorianHubl/AnimationStack/blob/main/Animation2.gif">


### ForEachAnimation

The ForEachAnimation is a ForEach-Loop which animate the views simmilar to the AnimationStack.

The Elements in the provided Array must conform to the Hashable protocol.

```swift
ForEachAnimation(["SwiftUI", "is", "awesome"]) { i in
    Text(i)
}
 ```
 
 <img src="https://github.com/FlorianHubl/AnimationStack/blob/main/Animation3.gif">


The ForEachAnimation is readonly. You can not change values from the Array in the Stack via a Binding. You can customise the ForEachAnimation simmilarly to the AnimationStack.
