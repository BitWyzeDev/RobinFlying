//
//  GameScene.swift
//  FlyingRobin
//
//  Created by Scott Richards on 9/30/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    weak var sceneDelegate: MyGameSceneDelegate?
    var robinCharacter: SKSpriteNode!
    var repeatFlightAction: SKAction?
    var continueFlying = false   // if this is true the Robin continues to fly in the same direction past where the user tapped
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        // Step 1: Create a sprite and add it to the scene
        robinCharacter = SKSpriteNode(imageNamed: "Robin Flying_00")
        let x = screenWidth * 0.1
        let y = screenHeight * 0.5
        print("x: \(x) y: \(y)")
        robinCharacter.position = CGPoint(x: x, y: y)
        addChild(robinCharacter)
        
        // Step 2: Load animation frames
        var frames: [SKTexture] = []
        for i in 0...81 {  // Assuming you have 5 frames named character1, character2, ..., character5
            if i < 10 {
                frames.append(SKTexture(imageNamed: "Robin Flying_0\(i)"))
            } else {
                frames.append(SKTexture(imageNamed: "Robin Flying_\(i)"))
            }
        }
        robinCharacter.scale(to: CGSize(width: 333, height: 258))
        robinCharacter.setScale(0.25)
        
        // Step 3: Create an animation action
        let animationAction = SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: true)

        // Step 4: Run the animation repeatedly
        let repeatAnimation = SKAction.repeatForever(animationAction)
        robinCharacter.run(repeatAnimation)
        
        // Step 5: Run the flight animation in a loop
        runFlightAnimation()
        
//        let flightPath = getFlightPath(x: x, y: y)
//        let flyAcrossScreen = SKAction.group([flightPath, repeatAnimation])
//        let repeatFlight = SKAction.repeatForever(flyAcrossScreen)
//        robinCharacter.run(repeatFlight)
    }
    
    // Calculate a flight path
    func getFlightPath(x: CGFloat, y: CGFloat) -> SKAction {
        // 2. Define the flight path
        let path = CGMutablePath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: self.size.width + 100, y: y + 100))

        
        // 3. Create the follow path action
        let followPath = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 5.0)
        return followPath
    }
    
    // Function to run the flight path
        func runFlightAnimation() {
            // Set the starting position to the left of the screen
            let startX = -robinCharacter.size.width // Start off-screen on the left
            let y = self.size.height * 0.5
            robinCharacter.position = CGPoint(x: startX, y: y)
            
            // Define the flight path from left to right up by 100 pixels
          //  let flightPath = SKAction.move(to: CGPoint(x: self.size.width + robinCharacter.size.width, y: y + 100), duration: 5.0)
            
            // Define the flight path
            var flightPath = CGMutablePath()
            flightPath.move(to: CGPoint(x: 100, y: 100))
            flightPath.addCurve(to: CGPoint(x: 400, y: 400), control1: CGPoint(x: 150, y: 300), control2: CGPoint(x: 300, y: 200))
            flightPath.addLine(to: CGPoint(x: 500, y: 100))
            // Create an action with the flight path
            let flightAction = SKAction.follow(flightPath, asOffset: false, orientToPath: false, duration: 5.0)
            
            // Reset the position and repeat the flight
            let resetPosition = SKAction.run { [weak self] in
                self?.robinCharacter.position = CGPoint(x: startX, y: y)
            }
            
            // Sequence of flight path and reset position
            let flyAndReset = SKAction.sequence([flightAction, resetPosition])
            
            // Repeat the flight forever
            let repeatFlight = SKAction.repeatForever(flyAndReset)
            robinCharacter.run(repeatFlight, withKey: "repeatFlightAction")
            self.repeatFlightAction = repeatFlight
        }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the first touch in the set
        if let touch = touches.first {
            // Get the location of the touch in the scene's coordinate system
            let location = touch.location(in: self)
            
            // Calculate the angle between the current position and the touch location
            let dx = location.x - robinCharacter.position.x
            let dy = location.y - robinCharacter.position.y
            let angle = atan2(dy, dx)  // Calculate angle in radians
            
            // Rotate the robinCharacter to point towards the destination
            robinCharacter.zRotation = angle
            
            // If we are moving right to left we need to flip the Robin to point to the left instead of the right so it is not flying upside down!
            
            // Determine the direction of movement
            let movingLeft = location.x < robinCharacter.position.x
            
            // Flip the sprite based on the direction
//            robinCharacter.xScale = movingLeft ? -1 : 1
            
            // Create an action to move the sprite to the touch location
            var moveAction = SKAction.move(to: location, duration: 0.5)
            if continueFlying {
                // Calculate an extended destination point (e.g., 200 points beyond the touch location)
                let distance: CGFloat = 200  // Distance beyond the touch point
                let extendedX = location.x + cos(angle) * distance
                let extendedY = location.y + sin(angle) * distance
                let extendedPoint = CGPoint(x: extendedX, y: extendedY)
                moveAction = SKAction.move(to: extendedPoint, duration: 0.5)
            }
            
            // Optionally, add an easing effect if desired (e.g., ease-in-out)
            moveAction.timingMode = .easeInEaseOut
            
            // Stop the current repeating flight path
            robinCharacter.removeAction(forKey: "repeatFlightAction")
            // Run the move action on the sprite
            robinCharacter.run(moveAction)
            let position = touch.location(in: self)
            debugPrint("touch.location: \(position)")
            sceneDelegate?.onTouchDown(pos: position, angle: angle)
//            self.touchDown(atPoint: touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // The user has tapped the screen. Make the bird fly in this direction
    
//    func touchDown(atPoint pos : CGPoint) {
//        sceneDelegate?.onTouchDown(pos: pos)
//    }
}
