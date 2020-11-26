
## アラームが知っていて欲しいこと

ID：削除するのに必要
時間：起動するのに必要
オンかオフか：確認するのに必要
Intentで流すTextの形はどうするか[{"uniqueId":uniqueId}, {"ringing':true"}]で流すかなー。


 AlarmState
-  int id, 
- String time, 
- bool mount, 
- bool ringing, 
- bool used

## 必要なファンクション
- 1分ごとにチェック（初期化と状態の読み込み）
- 初期化とチェックは分けよう。
- alarm.set(time)とalarm.dissmiss()だけでOKじゃないのかな
- alarm.setはアラームをセットする。
- alarm.dismissはアラームをオフにする。
- al

## 必要な画面
- ホーム画面
- アラームの設定画面
- 鳴動画面
- 基本設定画面
  - 何時にアラームをリセットするか
  - 色などの設定

## 問題
- 初期化するときに前の日の日付のアラームになってしまうこと。
  - 解法としては最初の読み込みのときに当日の時間になるように調整する。→OK
- `SharedPreferences.clear()`をするとなんか変になってしまうこと。  
  　　　
  →こちらは使わずに別の方法を考えることにする。→キーがない状況のときにSetStringしないようにした。

