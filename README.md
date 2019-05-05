<h1>自分の移動履歴を知る</h1>

<a href="https://takeout.google.com/settings/takeout/custom/location_history">Googleの移動履歴情報</a>をダウンロードして、
ある日に自分がどこにいたかを簡単に知ることができるプログラム。

<h2>準備</h2>

<ul>
  <li><a href="https://takeout.google.com/settings/takeout/custom/location_history">Googleのページ</a>から「ロケーション履歴.json」を取得して
    <code>dateloc.rb</code>のフォルダに置いておく
  </li>
</ul>

<h2>利用例</h2>

<pre>
  % ruby dateloc.rb 2019/5/5 | pbcopy
</pre>

これをScrapboxにペーストすると<code>2019/5/5</code>の移動履歴がわかる

