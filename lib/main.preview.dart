
import 'package:flutter/widgets.dart';
import 'package:preview/preview.dart';
import 'todo_list.dart';  
void main() {
  runApp(_PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreviewPage(
      path: 'todo_list.dart',
      providers: () => [
        WidgetPreview(), 
        
      ],
    );
  }
}
  