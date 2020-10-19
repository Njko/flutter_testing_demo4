import 'package:flutter/material.dart';
import 'package:preview/preview.dart';

/*class TodoList extends StatelessWidget {
  /*
  @override
  Widget build(BuildContext context) {
    //1 Test 'Look at place to add a Todo' fails because it cannot find a Texfield -> provide a Texfield
    //return Text("Hello World");

    //2 Test 'Look at place to add a Todo' fails because TextField requires a Material widget ancestor
    // -> improve TestContextWidget to introduce Scaffold
    //3 Test 'Look at place to add a Todo' fails beacause MediaQuery.of() called with a context that does not contain a MediaQuery
    // -> improve TestContextWidget to introduce MaterialApp
    //4 Test 'Enter text in the Todo' works because it finds the text in the Textfield
    //5 Test 'Add an item in the Todo' fails because it tries to tap on a non existing FloatActionButton 
    // -> Introduce the minimum number of Widget to make that test succeed
    return TextField();
  }*/

  
  @override
  Widget build(BuildContext context) {
    //6 Test 'Add an item in the Todo' works because it finds 'hi' on the Texfield
    // -> update test to introduce key to find specific text elsewhere
    //7 Test 'Add an item in the Todo' fails because it cannot find an item with specific key
    // -> introduce key on any item that is not Textfield
    //8 Test 'Add an item in the Todo' works because it found an item with the specific id
    // -> change test to make sure that a child of widget containing key has text 'hi'
    //9 Test 'Add an item in the Todo' fails because it cannot find a matching ancestor to our text 'hi'
    // -> change code to build child containing 'hi' when pressing button
    // => change TodoList from Stateless to Stateful
    return Column(
      children: [
        TextField(),
        FloatingActionButton(
          key: Key('todo1'),
          onPressed: () {},
        ),
      ],
    );
  }
}
*/

//10 Perfectly valid solution to validate our tests
// -> add new test to add a new item in the todolist
//11 Test 'Add two items in the list' fails because it cannot find the text hello
// and if you change 'hi' to 'hello' the 'Add an item in the Todo' fails
// -> time to add a proper implementation
/*class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _isPressed = true;
            });
          },
        ),
        Container(
          key: Key('todo1'),
          child: _isPressed ? Text('hi') : Container(),
        )
      ],
    );
  }
}*/

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  //13 provide a controller for the Textfield to retrieve the text
  final _controller = TextEditingController();
  //14 provide a store for the todolist => part of State of Widget
  final _todos = <String>[];
  var idIncrement = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
        ),
        FloatingActionButton(
          onPressed: () {
            //15 we will update the state of the widget when pressing the button
            setState(() {
              //16 add a way to link the textfield controller to the model
              _todos.add(_controller.text);
              //17 empty the textfield
              _controller.clear();
            });
          },
        ),
        //18 All tests fail because ListView is potentially infinite height
        //-> wrap in Expanded Container
        Expanded(
          child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (BuildContext ctx, int index) {
                //20 Replace this Container by a Dismissible
                return Dismissible(
                  //21 Make sure the key is unique: https://www.youtube.com/watch?v=kn0EOS-ZiIc
                  key: Key('${_todos[index]}$index'),
                  //19 Wrap Text in ListTile to give basic layout and default dimensions
                  child: ListTile(title: Text(_todos[index])),
                  onDismissed: (direction) {
                    //22 SetState is optional here because pressing the action button
                    //will trigger the setState and rebuild the whole widget
                    _todos.removeAt(index);
                    //});
                  },
                );
              }),
        ),
      ],
    );
  }
}

class WidgetPreview extends PreviewProvider {
  @override
  List<Preview> get previews {
    return [
      Preview(
        frame: Frames.iphone8,
        child: TodoList(),
      ),
    ];
  }
}
