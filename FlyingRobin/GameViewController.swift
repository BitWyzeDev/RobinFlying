//
//  GameViewController.swift
//  FlyingRobin
//
//  Created by Scott Richards on 9/30/24.
//

import UIKit
import SpriteKit
import GameplayKit

protocol MyGameSceneDelegate: AnyObject {
    func onTouchDown(pos: CGPoint)
}

class GameViewController: UIViewController, MyGameSceneDelegate {

    @IBOutlet weak var posLabel: UILabel!
    
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        scene.sceneDelegate = self
        debugPrint("scene.sceneDelegate: \(scene.sceneDelegate)")
        self.gameScene = scene
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func onTouchDown(pos: CGPoint) {
        let posString = String(format: "x: %.1f, y: %.1f", pos.x, pos.y)
        posLabel.text = posString
    }
    
    func convertToSpriteKitCoordinates(uiPoint: CGPoint) -> CGPoint {
        // Get the center of the screen
        let centerX = self.view.frame.width / 2
        let centerY = self.view.frame.height / 2
        
        // Convert to SpriteKit coordinates
        return CGPoint(x: uiPoint.x - centerX, y: uiPoint.y - centerY)
    }
}

