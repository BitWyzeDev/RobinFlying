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
    @IBOutlet weak var xValue: UILabel!
    @IBOutlet weak var yValue: UILabel!
    
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
        let stringXValue = "\(pos.x)"
        xValue.text = stringXValue
        let stringYValue = "\(pos.y)"
        yValue.text = stringYValue
    }
    
}

