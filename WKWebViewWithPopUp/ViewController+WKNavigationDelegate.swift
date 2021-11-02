//
//  ViewController+WKNavigationDelegate.swift
//  WKWebViewWithPopUp
//
//  Created by haanwave on 2021/11/02.
//

import UIKit
import WebKit

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        /// webView 로드 시작
        print("--->[webView:didStartProvisionalNavigation]")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// webView 로드 완료, 완료 후 webView 상황에 맞게 버튼 상태 세팅
        configureBackwardAndForwardButton()
        print("--->[webView:didFinish]")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        /// webView 로드 실패
        print("--->[webView:didFail]", error)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        /// WKWebView HTTPURLResponse 정보를 확인하기 위한 Delegate
        print("--->[webView:decidePolicyFor]")
        /// 사설 인증서로 구성된 서버로 접근이 가능하도록 하는 코드 ex) 도메인 연결이 되지 않은 사이트
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        /// webView가 요청에 대한 서버 리디렉션을 수신했음을 알리는 Delegate
        print("--->[webView:didReceiveServerRedirectForProvisionalNavigation]")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        /// Self signed SSL Certificate on WKWebView
        print("--->[webView:didReceive challenge]")
        /// 사설 인증서로 구성된 서버로 접근이 가능하도록 하는 코드 ex) 도메인 연결이 되지 않은 사이트
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
}
