//
//  ViewController.swift
//  catchKenny
//
//  Created by Appcent on 6.01.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var randomView: UIView!

    var rickImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rick")
        return imageView
    }()

    var score: Int = 0
    var highScore: Int = 0
    var timeConstant: Int = 15
    var timeTimer = Timer()
    var imageTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        randomView.addSubview(rickImageView)

        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")

        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "HIGHSCORE: \(highScore)"
        } else {
            guard let storedHighScore = storedHighScore as? Int else { return }
            highScore = storedHighScore
            highScoreLabel.text = "HIGHSCORE: \(highScore)"
        }

        timeLabel.text = "TIME: \(timeConstant)"
        scoreLabel.text = "SCORE: \(score)"


        rickImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        rickImageView.addGestureRecognizer(recognizer)

        timeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        imageTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(changeLocationOfImage), userInfo: nil, repeats: true)
    }

    @objc func changeLocationOfImage() {
        let imageWidth = (randomView.frame.width - 60) / 3
        let imageViewYPositions : [CGFloat] = [15,130,245]
        let imageViewXPositions : [CGFloat] = [15,imageWidth + 30,(2 * imageWidth) + 45]
        rickImageView.frame = CGRect(x: imageViewXPositions.randomElement()!, y: imageViewYPositions.randomElement()!, width: imageWidth, height: 100)
    }

    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "SCORE: \(score)"
    }

    @objc func countDown() {
        timeConstant -= 1
        timeLabel.text = "TIME: \(timeConstant)"

        if timeConstant == 0 {
            timeTimer.invalidate()
            imageTimer.invalidate()

            if self.score > self.highScore {
                self.highScore = self.score
                self.highScoreLabel.text = "HIGHSCORE: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highScore")
            }

            let alert = UIAlertController(title: "Time's up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { _ in
                self.score = 0
                self.scoreLabel.text = "SCORE: \(self.score)"
                self.timeConstant = 15
                self.timeLabel.text = "TIME: \(self.timeConstant)"
                self.timeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.imageTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.changeLocationOfImage), userInfo: nil, repeats: true)
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }

    }

}

