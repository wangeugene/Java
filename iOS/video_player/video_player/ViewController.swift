//
//  ViewController.swift
//  video_player
//
//  Created by euwang on 10/13/25.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          playVideo()
      }

      func playVideo() {
          // Make sure the file name matches exactly what’s in your bundle
          guard let path = Bundle.main.path(forResource: "test", ofType: "mp4") else {
              print("⚠️ video file not found")
              return
          }

          let player = AVPlayer(url: URL(fileURLWithPath: path))
          let playerVC = AVPlayerViewController()
          playerVC.player = player
          playerVC.modalPresentationStyle = .fullScreen

          // Present the player
          present(playerVC, animated: true) {
              player.play()
          }
      }
}

