import UIKit
import Lottie

@objc public class GLLOTAnimationView: UIView {
    
    // MARK: - Property
    @objc public var animationView: LottieAnimationView!
    private var zipUrl :String = ""
    @objc public var playFlag = false
    
    lazy var baseUrl :String = {
        let result = NSTemporaryDirectory()
        if !FileManager.default.fileExists(atPath: result){
            do{
                try FileManager.default.createDirectory(atPath: result, withIntermediateDirectories: true, attributes: nil)
            }catch{
                
            }
        }
        
        return result
    }()
    
    @objc public var loopAnimation: Bool = true {
        didSet {
            if loopAnimation {
                animationView.loopMode = .loop
            } else {
                animationView.loopMode = .playOnce
            }
        }
    }
    
    @objc public var  isPlaying: Bool {
       return animationView.isAnimationPlaying
    }
    
    @objc public var completionBlock: ((_ finish: Bool) -> Void)? = nil
    var archiveDidUnzipBlock: (LottieAnimation.DownloadClosure)? = nil
    // MARK: - Life Cycle
    @objc public  init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        
        //【1】优先本地bundle查找资源
        var lottiePath = Bundle.main.path(forResource: name, ofType: "json") ?? ""
        if lottiePath.isEmpty {
            let bundlePath = Bundle.main.path(forResource: "EaseIMKit", ofType: "bundle") ?? ""
            lottiePath = bundlePath+"/"+name+".json"
        }
        //初始化动画对象
        var animation:LottieAnimation? = LottieAnimation.filepath(lottiePath)
        //初始化视图
        animationView = LottieAnimationView(animation: animation)
        animationView.frame = self.bounds;
        //设置imageProvider目录（.json的上级目录地址）
        let tempUrl = NSURL.init(fileURLWithPath: lottiePath)
        var lottieImagePath = tempUrl.deletingLastPathComponent?.absoluteString ?? ""
        var imageProvider = FilepathImageProvider.init(filepath: lottieImagePath)
        animationView.imageProvider = imageProvider
        animationView.loopMode = .loop
        
        if #available(iOS 13.0, *) {
            animationView.backgroundBehavior = .pauseAndRestore
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        addSubview(animationView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func didMoveToWindow() {
        if #available(iOS 13.0, *) {
            return
        }
        if playFlag && !animationView.isAnimationPlaying && animationView.loopMode == .loop {
            animationView .play()
        }
    }
    
    @objc func didBecomeActive() {
        if #available(iOS 13.0, *) {
            return
        }
        if playFlag && !animationView.isAnimationPlaying && animationView.loopMode == .loop {
            animationView .play()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = self.bounds
    }
    
    // MARK: - Method
    @objc  public func setName(_ name: String) {
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
    }
    
    @objc public func play() {
        animationView.play { [weak self](finish) in
            if let completionBlock = self?.completionBlock {
                completionBlock(finish)
            }
        }
        playFlag = true
    }
    
    @objc public func playWithCompletion(_ completion: @escaping (Bool) -> Void) {
        animationView.play { [weak self](finish) in
            completion(finish)
            
            if let completionBlock = self?.completionBlock {
                completionBlock(finish)
            }
        }
    }
    
    @objc public func stop() {
        animationView.stop()
        playFlag = false
    }
    
    @objc public func pause() {
        animationView.pause()
        playFlag = false
    }
    
    @objc public func playToProgress(_ progress: CGFloat) {
        animationView.play(fromProgress: progress, toProgress: progress, loopMode: .playOnce, completion: nil)
    }
    
    @objc public func setupContentMode(_ mode: UIView.ContentMode) {
        animationView.contentMode = mode
    }
    
}


