import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../Network/Local/Cach_Helper.dart';
import '../../../Shared/styles/colors.dart';
import '../LoginScreen/ShopLoginScreen.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.title ,
    required this.body ,
    required this.image
}) ;
}
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  void submit(){
    CachHelper.saveData(key: 'onBoarding', value: true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ShopLogin()), (route) => false);
  }
  var isLast = false ;
  void initState() {
    // TODO: implement initState
    super.initState();
    print('isLast');
    print(isLast);
  }
  @override
  Widget build(BuildContext context) {
    var boardController = PageController() ;
    List<BoardingModel> boarding = [
      BoardingModel(title: 'On Boarding Title 1', body: 'On Boarding Body 1', image: 'assets/images/onboard1.jpg'),
      BoardingModel(title: 'On Boarding Title 2', body: 'On Boarding Body 2', image: 'assets/images/onboard3.jpeg'),
      BoardingModel(title: 'On Boarding Title 3', body: 'On Boarding Body 3', image: 'assets/images/onboard4.png'),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){submit();},
              child: Text('Skip',style: TextStyle(color: defaultColor, fontSize:18.0),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child:
            PageView.builder(
              onPageChanged: (int index){
                if(index == boarding.length - 1 ){
                  print('last');
                  setState(() {
                    isLast = true ;
                    print(isLast );
                  });
                }else{
                  print('notlast');
                  print(isLast) ;
                  setState(() {
                    isLast = false ;
                  });
                }
              },
              controller: boardController,
              itemBuilder: (context,index) => buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
            )),
            SizedBox(height: 40.0,),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                  effect: ExpandingDotsEffect(
                    dotColor: defaultColor,
                    dotHeight: 10.0,
                    expansionFactor: 4.0,
                    dotWidth: 10.0,
                    spacing: 5.0,
                    activeDotColor: defaultColor,
                  ),
                ),
                Spacer(),
                FloatingActionButton(onPressed: (){
                  if(isLast == true){
                    submit();
                    print('yes') ;
                  }else{
                    print('no') ;
                    boardController.nextPage(duration: Duration(milliseconds: 750), curve: Curves.fastEaseInToSlowEaseOut) ;
                  }
                },
                  child:Icon(Icons.arrow_forward_ios , color: Colors.white,
                  ),)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel board)=> Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(child: Image(image: AssetImage('${board.image}'))),
    Text('${board.title}',style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 22),),
    SizedBox(height: 30.0,),
    Text('${board.body}',style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 18.0),),
    SizedBox(height: 15.0,),
  ],);
}
