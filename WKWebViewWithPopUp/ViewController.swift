//
//  ViewController.swift
//  WKWebViewWithPopUp
//
//  Created by haanwave on 2021/11/02.
//

import UIKit
import WebKit

let sampleURL = URL(string: "https://apple.com")!
let requestURL = URLRequest(url: sampleURL)

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backwardButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var popupWebViews = [WKWebView]()
    var currentWebView: WKWebView {
        return popupWebViews.isEmpty ? webView : popupWebViews.last!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        currentWebView.load(requestURL)
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        /// javaScript 사용 여부
        if #available(iOS 14, *) {
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            webView.configuration.defaultWebpagePreferences = preferences
        }
        else {
            webView.configuration.preferences.javaScriptEnabled = true
            /// user interaction없이 윈도우 창을 열 수 있는지 여부를 나타냄. iOS에서는 기본값이 false이다.
            webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        }
    }
    
    func createNewWebView(_ config: WKWebViewConfiguration) -> WKWebView {
        /// autoLayout 되어 있는 webView와 frame을 같게 한다.
        let newWebView = WKWebView(frame: webView.frame,
                                   configuration: config)
        newWebView.navigationDelegate = self
        newWebView.uiDelegate = self
        newWebView.allowsBackForwardNavigationGestures = true
        view.addSubview(newWebView)
        popupWebViews.append(newWebView)
        return newWebView
    }
    
    @IBAction func tapBackwardButton(_ sender: UIBarButtonItem) {
        if currentWebView.canGoBack {
            currentWebView.goBack()
            return
        }
        
        if popupWebViews.count > 0 {
            let last = popupWebViews.popLast()
            last?.removeFromSuperview()
            /// webView 로드가 완료되면 버튼을 재설정하기는 하지만
            /// 팝업창을 뒤로가기할 경우(닫을 경우) 로드 완료 delegate가 호출되지 않기 때문에 이곳에서 버튼을 재설정한다.
            configureBackwardAndForwardButton()
        }
    }
    
    /// 뒤로 & 앞으로가기 버튼 세팅
    func configureBackwardAndForwardButton() {
        /// webView가 뒤로 이동할 수 있거나 팝업창이 있는 경우 뒤로가기 활성화
        backwardButton.isEnabled = currentWebView.canGoBack || popupWebViews.count > 0
        /// webView가 앞으로 이동할 수 있는 경우 활성화
        forwardButton.isEnabled = currentWebView.canGoForward
    }
    
    @IBAction func tapForwardButton(_ sender: UIBarButtonItem) {
        if currentWebView.canGoForward {
            currentWebView.goForward()
        }
    }
    
    @IBAction func tapHomeButton(_ sender: UIBarButtonItem) {
        currentWebView.load(requestURL)
    }
    
    @IBAction func tapRefreshButton(_ sender: UIBarButtonItem) {
        currentWebView.reload()
    }
    
    @IBAction func tapShareButton(_ sender: UIBarButtonItem) {
        guard let shareURL = currentWebView.url else { return }
        let items = [shareURL]
        let activity = UIActivityViewController(activityItems: items,
                                                applicationActivities: nil)
        show(activity, sender: nil)
    }
    
    /// 공유 관련 html이 있는 경우만 공유 버튼을 활성화하고 싶을 경우 해당 코드 사용
    //    func configureShareButton() {
    //        currentWebView.evaluateJavaScript("document.body.innerHTML") { data, error in
    //            guard error == nil else {
    //                self.shareButton.isEnabled = false
    //                return
    //            }
    //            /// html body 안에 'share' 가 있을 경우 공유 버튼 활성화
    //            /// html에 'share'가 아닌 다른 단어로 되어있다면 해당 단어 사용
    //            if let html = data as? String {
    //                self.shareButton.isEnabled = html.contains("share")
    //            }
    //        }
    //    }
}
