# Chatty Riko
Redefine messaging app experience
Developed in a hackathon in try Swift! Tokyo 2017  

Inspiration / 着想
------
We often use a lot of chat apps, like Facebook, Twitter DM, Slack or LINE. Sometimes we forget where is taking this topic, so we need merged list. Some app have published web api, so we think it’ll be resolved, and we often see tutorials of Chat app using Firebase or Realm, but I haven't tried it.

最近LINE / Facebook / Slack / TwitterのDMなど、色んなチャットアプリが乱立していて、どこで何の会話が行われているかわからないので一覧性のあるものがほしいと思いました。 また、FirebaseやRealmでチャットアプリを作ってみたというチュートリアルレベルのものは良く見るのですが、本当に解決できるのかどうか僕も確かめたことがありませんでした。

What it does / 何をするのか
------
We use twitter api and original chat using Firebase to get data from those services, and gather into one timeline.
TwitterのAPIとFirebaseを使ったオリジナルチャットを使って、データを取得し、ひとつのタイムラインに集約します。

How we built it / どうやってしたのか
------
We have used oAuth for Authorization and Web API’s of Twitter and Slack for retrieving the messages. The frameworks used for building this app 
oAuth認証と, TwitterやSlackのWebAPIを用いて、データの取得を行いました。また、Firebase Realtime Databaseと、以下のライブラリを使ってアプリを作成しました。

- Firebase Realtime Database
- Alamofire
- FHSTwitterEngine.
- SwiftyJSON
- JSQMessageViewController
- PagingMenuController

Challenges We ran into / 挑戦したこと
------
1. Twitter and Slack did not have SDK’s for iOS so we had to use Web API’s for retrieving messages / TwitterやSlackはiOSのSDKがないので、メッセージを受信するのにWeb APIを使う必要があったこと
2. Understanding oAuth / oAuthへの理解
3. Making Original Chat using Firebase / Firebaseを使ったオリジナルチャットの作成
4. Communicating with team members and using google translate to convert from English to Japanese and vice versa / 英語や日本語を話すチームメンバー間でコミュニケーションを取ること 
5. Limited time for developing / より限られた時間での開発


What's next for Chatty Riko for iOS / 今後の展望
------
- By using more other SNS api, we can gather more into one. / 他のSNSのAPIを使うことで、より集約されたチャットアプリをつくります。
- Support posting off direct message. / ダイレクトメッセージへの投稿のサポート
- Support more than 1 slack team. / Slack1チーム以上のサポート
- Support more languages and translation / 多言語サポートと送信時の翻訳
- Moving calling api to server-side swift to use from Android. / Androidからでも使えるように、APIをサーバーサイドSwiftへ移行します。
