import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/rendering.dart' as prefix0;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(backgroundColor: Colors.black, body: HomeContent(),),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>{

  int _minute;
  int _hour;
  int _second;
  Timer _everySec;
  

  @override
  void initState() {

    super.initState();
    setState(() {
        _minute = TimeOfDay.now().minute;
        _hour = TimeOfDay.now().hour;
        _second = DateTime.now().second;

       
        
        
    });
    _everySec =  Timer.periodic(Duration(seconds: 1), (Timer _){
      setState(() {
        _minute = TimeOfDay.now().minute;
        _hour = TimeOfDay.now().hour;
        _second = DateTime.now().second;
    });

    });
    
   
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        decoration: BoxDecoration(border: Border.all(width: 1.3, color: Color.fromRGBO(234, 32, 39,1.0)), shape: BoxShape.circle),
        height: 400.0,
        width: 400.0,
        child: Center(
          child: new CustomPaint(
            painter: new MyPainter(
                hour: _hour,
                minute: _minute,
                second: _second,
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter{
  final int hour;
  final int minute;
  final int second;

  MyPainter({this.hour, this.minute, this.second});

  Paint generatePaints({Paint paint, Color color, double strokeWidth=15, PaintingStyle style = PaintingStyle.stroke}){

    paint.color = color;
    paint.strokeCap = StrokeCap.butt;
    paint.style = style;
    paint.strokeWidth = strokeWidth;

    return paint;
  }

  TextPainter textPainter({TextPainter textPaint,String text, Color color}){
    textPaint.textAlign = TextAlign.center;
    textPaint.textDirection = TextDirection.ltr;
    textPaint.text = new TextSpan(
          text: text.toString(),
          style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w600));
    textPaint.layout();

    return textPaint;
  }


  void drawArcCanvas({Canvas canvas,Offset center, double radius, double radian, Paint path}){
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: radius),
        -pi/2,
        radian,
        false,
        path
    );
  }

  void drawCircleCanvas({Canvas canvas, Offset center, Paint path, double radian, double parentRadius, double radius = 15}){
    canvas.save();
    canvas.rotate(-pi/2);
    canvas.rotate(radian);
    canvas.translate(parentRadius, 0);
    canvas.drawCircle(
        center,
        radius,
        path
    );

    canvas.restore();
  }


  void drawText({Canvas canvas, TextPainter textPaint, double parentRadius, double radian, double maxValue}){
    canvas.save();
    canvas.rotate(-pi/2);
    canvas.rotate(radian);
    canvas.translate(parentRadius, 0);

    final int quadSide = (maxValue / (maxValue/3)).floor();

    switch (quadSide) {
      case 0:
        canvas.rotate(pi/2-radian);
        break;
      case 1:
        canvas.rotate(pi-pi/2 - radian);
        break;
      case 2:
        canvas.rotate(pi-pi/2 - radian);
        break;
      case 3:
        canvas.rotate(pi/2 - radian);
        break;
    }


    textPaint.paint(canvas, Offset(-textPaint.width/2, -textPaint.height/2));


    canvas.restore();
    
  }


  @override
  void paint(Canvas canvas, Size size) {


    // Colors
    Color _hourColor = Colors.pink;
    Color _minuteColor = Colors.cyan;
    Color _secondColor = Color.fromRGBO(104, 109, 224,1.0);
    // Remaining Time Colors
    Color _hourRemainingColor = Color.fromRGBO(109, 33, 79,0.3);
    Color _minuteRemainingColor = Color.fromRGBO(39, 60, 117,0.3);
    Color _secondRemaingColor = Color.fromRGBO(27, 20, 100,0.3);


    // Radians
    List<double> radians = timeToRadian(hour, minute, second);
    double _hourRadian = radians[0];
    double _minuteRadian = radians[1];
    double _secondRadian = radians[2];


    // Radius from center
    double _hourRadius = 60;
    double _minuteRadius = 125;
    double _secondRadius = 190;


    // Remaing time
    int _hoursRemaining = 24 - hour;
    int _minutesRemaining = 60 - minute;
    int _secondsRemaining = 60 - second;

    // Ramaing radians
    List<double> remainingRadians = timeToRadian(_hoursRemaining, _minutesRemaining, _secondsRemaining);
    double _hourRemainingRadian = remainingRadians[0];
    double _minuteRemainingRadian = remainingRadians[1];
    double _secondRemainingRadian = remainingRadians[2];

    // Text Paint Labels
    TextPainter _hourLabel = textPainter(textPaint: TextPainter(), color: _hourColor, text: (hour-12).toString());
    TextPainter _minuteLabel = textPainter(textPaint: TextPainter(), color: _minuteColor, text: minute.toString());


    // Hour Paint
    Paint _hourLine = generatePaints(paint:Paint(), color:_hourColor);
    Paint _hourRemainingLine = generatePaints(paint:Paint(), color:_hourRemainingColor);
    Paint _hourBubbleOutline = generatePaints(paint:Paint(), color:_hourColor, strokeWidth: 1.2, style: PaintingStyle.fill);
    Paint _hourBubble = generatePaints(paint:Paint(), color:Colors.black, strokeWidth: 1.2, style: PaintingStyle.fill);
    
    // Minute Paint
    Paint _minuteLine = generatePaints(paint:Paint(), color:_minuteColor);
    Paint _minuteRemainingLine = generatePaints(paint:Paint(), color:_minuteRemainingColor);
    Paint _minuteBubbleOutline = generatePaints(paint:Paint(), color:_minuteColor, strokeWidth: 1.2, style: PaintingStyle.fill);
    Paint _minuteBubble = generatePaints(paint:Paint(), color:Colors.black, strokeWidth: 1.2, style: PaintingStyle.fill);
    
    // Hour Paint
    Paint _secondLine = generatePaints(paint:Paint(), color:_secondColor, strokeWidth: 5);
    Paint _secondRemainingLine = generatePaints(paint:Paint(), color:_secondRemaingColor, strokeWidth: 5);
    Paint _secondBubbleOutline = generatePaints(paint:Paint(), color:Color.fromRGBO(234, 32, 39,1.0), strokeWidth: 1.2, style: PaintingStyle.fill);
    Paint _secondBubble = generatePaints(paint:Paint(), color:_secondColor, strokeWidth: 1.2, style: PaintingStyle.fill);



    Offset center  = new Offset(size.width/2, size.height/2);
    

    // draw hour arc
    drawArcCanvas(canvas: canvas, center: center, radian: _hourRadian, radius: _hourRadius, path: _hourLine);
    drawArcCanvas(canvas: canvas, center: center, radian: -_hourRemainingRadian, radius: _hourRadius, path: _hourRemainingLine);
    drawCircleCanvas(canvas: canvas, parentRadius: _hourRadius ,path: _hourBubbleOutline, center: center, radian: _hourRadian);
    drawCircleCanvas(canvas: canvas, parentRadius: _hourRadius ,path: _hourBubble, center: center, radian: _hourRadian, radius: 14);
    drawText(canvas: canvas ,textPaint: _hourLabel, parentRadius: _hourRadius, radian: _hourRadian, maxValue: 24);
    
    // draw minute arc
    drawArcCanvas(canvas: canvas, center: center, radian: _minuteRadian, radius: _minuteRadius, path: _minuteLine); // Actual Minutes
    drawArcCanvas(canvas: canvas, center: center, radian: -_minuteRemainingRadian, radius: _minuteRadius, path: _minuteRemainingLine); // Remaining Minutes
    drawCircleCanvas(canvas: canvas, parentRadius: _minuteRadius ,path: _minuteBubbleOutline, center: center, radian: _minuteRadian);
    drawCircleCanvas(canvas: canvas, parentRadius: _minuteRadius ,path: _minuteBubble, center: center, radian: _minuteRadian, radius: 14);
    drawText(canvas: canvas ,textPaint: _minuteLabel, parentRadius: _minuteRadius, radian: _minuteRadian, maxValue: 60);
    
    // draw second arc
    drawArcCanvas(canvas: canvas, center: center, radian: _secondRadian, radius: _secondRadius, path: _secondLine);
    drawArcCanvas(canvas: canvas, center: center, radian: -_secondRemainingRadian, radius: _secondRadius, path: _secondRemainingLine);
    drawCircleCanvas(canvas: canvas, parentRadius: _secondRadius ,path: _secondBubbleOutline, center: center, radian: _secondRadian);
    drawCircleCanvas(canvas: canvas, parentRadius: _secondRadius ,path: _secondBubble, center: center, radian: _secondRadian, radius: 14);






  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

    return true;
  }

}



List<double> timeToPercentageConverter(int hrs, int mint, int sec){
  double _baseHours = 12;
  double _baseMinutes = 60;
  double _baseSec = 60;

  // Convert from 24hr Format to 12hr Format
  if(hrs > _baseHours) hrs = hrs - 12;
  
  double _hrPercentage = (hrs / _baseHours) * 100;
  double _minutePercentage = (mint / _baseMinutes) * 100;
  double _secPercentage = (sec / _baseSec) * 100;

  return [_hrPercentage, _minutePercentage, _secPercentage];
}

List<double> percentageToRadianConverter(List<double> percentages){
  double _hrRadian = 2*pi* (percentages[0]/100);
  double _minuteRadian = 2*pi* (percentages[1]/100);
  double _secRadian = 2*pi* (percentages[2]/100);
  

  return [_hrRadian, _minuteRadian, _secRadian];
}

List<double> timeToRadian(int hrs, int mint, int sec){
  return percentageToRadianConverter(timeToPercentageConverter(hrs, mint, sec));
}