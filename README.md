# MVVM Pattern
MVVMとは?

MVVMとはModel-View-ViewModelの略

- Model
  - データを保持する
  - データの変更を通知する
  - データの変更を受け取る
  - データの変更を行う

- View
  - ユーザに見せる画面
  - ユーザの操作を受け取る
  - ユーザの操作をViewModelに伝える

- ViewModel
  - ViewとModelの橋渡しをする
  - ModelのデータをViewに伝える
  - Viewからの操作をModelに伝える
  - Modelのデータを変更する
  - Viewの表示を変更する
  - Viewの操作を受け取る
  - Viewの操作に応じてModelのデータを変更する

## フォルダ構成と命名規則
📁フォルダ構成と命名規則は以下のようにする
```
📁MVVM
lib/
|-- main.dart
|-- app/
|   |-- views/
|   |   |-- home_view.dart
|   |-- viewmodels/
|   |   |-- home_viewmodel.dart
|   |-- models/
|   |   |-- post.dart
|   |-- services/
|       |-- firebase_service.dart
```

common ディレクトリや riverpod のプロバイダーを配置する場所はプロジェクトとその規模に依存しますが、一般的なガイドラインは以下のようになります。

```
lib/
|-- main.dart
|-- common/
|   |-- constants.dart
|   |-- utils.dart
|-- providers/
|   |-- global_providers.dart
|-- app/
|   |-- views/
|   |   |-- home_view.dart
|   |-- viewmodels/
|   |   |-- home_viewmodel.dart
|   |-- models/
|   |   |-- post.dart
|   |-- services/
|       |-- api.dart
```