import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _ViewContentItems {
  final IconData icon;
  final String title;
  final String description;

  _ViewContentItems({
    this.icon,
    this.title,
    this.description
  });
}

class IntroScreen extends StatefulWidget {
  IntroScreen();

  @override
  State<StatefulWidget> createState() {
    return _IntroScreenState();
  }
}

class _IntroScreenState extends State<IntroScreen> {

  final List<_ViewContentItems> items = List<_ViewContentItems>();

  @override
  void initState() {
    super.initState();

    items.add(
      new _ViewContentItems(
        icon: Icons.check_circle_outline, 
        title: 'Create tasks with ease', 
        description: 'Its absolutely easy to create tasks with Todo. Just a few taps and you are good to go ...'
      )
    );
    items.add(
      new _ViewContentItems(
        icon: Icons.check_circle_outline, 
        title: 'Create tasks with ease', 
        description: 'Its absolutely easy to create tasks with Todo. Just a few taps and you are good to go ...'
      )
    );
    items.add(
      new _ViewContentItems(
        icon: Icons.check_circle_outline, 
        title: 'Create tasks with ease', 
        description: 'Its absolutely easy to create tasks with Todo. Just a few taps and you are good to go ...'
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Padding(
            padding: EdgeInsets.only(left: 56.0, right: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 60.0, bottom: 25.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        items[index].icon,
                        size: 60.0,
                        color: Colors.purple.shade500,
                      ),
                      Container(height: 30.0),
                      Text(
                        items[index].title,
                        style: TextStyle(
                          fontSize: 36.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(height: 16.0,),
                      Text(
                        items[index].description,
                        style: TextStyle(
                          fontSize: 19.0,
                          color: Colors.black,
                        ),
                      ),
                      index == 2 ?
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Container(
                            width: 160.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(40.0)
                            ),
                            child: MaterialButton(
                              textColor: Colors.white,
                              child: Text('Get Started'),
                              elevation: 5.0,
                              onPressed: () {}
                            ),
                          ),
                        ),
                      )
                      :
                      Container()
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}