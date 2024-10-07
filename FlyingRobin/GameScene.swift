//
//  GameScene.swift
//  FlyingRobin
//
//  Created by Scott Richards on 9/30/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var robinCharacter: SKSpriteNode!
    
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
            
            // Define the flight path from left to right
            let flightPath = SKAction.move(to: CGPoint(x: self.size.width + robinCharacter.size.width, y: y + 100), duration: 5.0)
            
            // Reset the position and repeat the flight
            let resetPosition = SKAction.run { [weak self] in
                self?.robinCharacter.position = CGPoint(x: startX, y: y)
            }
            
            // Sequence of flight path and reset position
            let flyAndReset = SKAction.sequence([flightPath, resetPosition])
            
            // Repeat the flight forever
            let repeatFlight = SKAction.repeatForever(flyAndReset)
            robinCharacter.run(repeatFlight)
        }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
}
