//
//  ViewController+WKUIDelegate.swift
//  WKWebViewWithPopUp
//
//  Created by haanwave on 2021/11/02.
//

import UIKit
import WebKit

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: nil,
                                   message: message,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인",
                                   style: .default) { _ in
            completionHandler()
        })
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let ac = UIAlertController(title: nil,
                                   message: message,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인",
                                   style: .default) { _ in
            completionHandler(true)
        })
        ac.addAction(UIAlertAction(title: "취소",
                                   style: .cancel) { _ in
            completionHandler(false)
        })
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let ac = UIAlertController(title: prompt,
                                   message: prompt,
                                   preferredStyle: .alert)
        ac.addTextField { textField in
            textField.text = defaultText
        }
        ac.addAction(UIAlertAction(title: "확인",
                                   style: .default) { _ in
            let inputText = ac.textFields?.first?.text
            completionHandler(inputText)
        })
        ac.addAction(UIAlertAction(title: "취소",
                                   style: .cancel) { _ in
            completionHandler(nil)
        })
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 팝업창(새 탭) 처리
        print("--->[createWebViewWith configuration]")
        return createNewWebView(configuration)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        /// 자바스크립트로 창을 닫기 위해 사용
        /// 여러 팝업창이 동시에 닫히는 문제를 방지하기 위해 가장 마지막 팝업을 먼저 닫는다.
        if popupWebViews.count > 0 {
            let last = popupWebViews.popLast()
            last?.removeFromSuperview()
            print("--->[webViewDidClose]")
        }
        /// 완료 후 webView 상황에 맞게 버튼 상태 세팅
        configureBackwardAndForwardButton()
    }
}
