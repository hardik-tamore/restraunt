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
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    print("Taped On Category");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Category(data[i].id, data[i].name),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage("${curl + data[i].img}"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Color(0xff667eea), BlendMode.softLight),
                      ),
                      backgroundBlendMode: BlendMode.screen,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 6.0,
                          left: 6.0,
                          width: 150.0,
                          child: Text(
                            "${data[i].name}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
