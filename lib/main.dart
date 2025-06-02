import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // このウィジェットはアプリケーションのルートです。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // アプリのテーマを設定します。
        //
        // 試してみよう: `flutter run` でアプリを起動し、
        // ここで `seedColor` を変更してホットリロードすると
        // ツールバーの色が変わる様子が確認できます。
        // カウンターの値はリロードしても保持されます。
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // このウィジェットはアプリのホーム画面です。State を持つため
  // 外観に影響するフィールドを管理できます。
  //
  // このクラスは状態の設定を保持します。親ウィジェットから渡された
  // `title` を利用して State の build メソッドで使用します。
  // Widget のフィールドは常に `final` で宣言します。

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.amber,
  ];

  void _incrementCounter() {
    setState(() {
      // setState を呼び出すことでフレームワークに状態が変わったことを知らせ、
      // build メソッドが再実行されて画面が更新されます。
      // setState を呼ばずに _counter を変更しても画面は更新されません。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // setState が呼ばれる度にこのメソッドが実行されます。
    // Flutter は高速にビルドできるよう最適化されているため、
    // 必要な部分だけを気軽に再構築できます。
    return Scaffold(
      appBar: AppBar(
        // ここを別の色に変えてホットリロードすると、AppBar の色だけが変わります。
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // MyHomePage から受け取ったタイトルを AppBar に表示します。
        title: Text(widget.title),
      ),
      body: Center(
        // Center は子ウィジェットを親の中央に配置するレイアウトです。
        child: Column(
          // Column は複数の子ウィジェットを縦方向に並べます。
          // mainAxisAlignment を指定して縦方向の配置を制御します。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                '$_counter',
                key: ValueKey<int>(_counter),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: _colors[_counter % _colors.length],
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // この末尾のカンマは自動フォーマットを整えるためのものです。
    );
  }
}
