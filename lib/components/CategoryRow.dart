import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import '../Category.dart';
import 'package:flutter/material.dart';
import '../theme/variables.dart';

class CategoryRow extends StatelessWidget {
  final data;
  CategoryRow(this.data);
  @override
  Widget build(BuildContext context) {
    return data == null
        ? Center(
            child: Loading(indicator: BallPulseIndicator(), size: 30.0,color: primary),
    
          )
        : GridView.builder(
            shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: MediaQuery.of(context).size.width/(550.0),
        ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int i){
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: (){
            print("Taped On Category");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context)=>Category(data[i].id,data[i].name),
              ),);
          },
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6.0,
                        offset: Offset(0.0,0.0),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage("${curl+data[i].img}"),
                      fit: BoxFit.cover,
                      // colorFilter:ColorFilter.mode(Color(0xff000000), BlendMode.softLight),
                      ),
                    backgroundBlendMode: BlendMode.screen,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text("${data[i].name}",style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
