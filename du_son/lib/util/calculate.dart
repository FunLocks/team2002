import 'dart:math' as math;

import 'package:du_son/models/sound_model.dart';
import 'package:flutter/material.dart';

abstract class ICalculate {
  List<double> solarAzimuth(double angle, double width, double height);
}

class Calculate implements ICalculate {
  // Widget build(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;
  //
  //   double angle = atan(200);
  //
  //   _calculate(size);
  // }

  List<double> solarAzimuth(double angle, double width, double height) {
    double tangent = math.tan(angle*(math.pi/180));
    List<double> _answer = [0, 0, 0, 0];

    //[x,y]
    //連立方程式１を配列で表現
    List<List<double>> A = [
      [tangent, -1],
      [0, 1]
    ];
    List right = [0, width / 2];
    List left = [0, -width / 2];
    //連立方程式２を配列で表現

    List top = [0, height / 2];
    List bottom = [0, -height / 2];

    List ans_right = [0, 0];
    List ans_left = [0, 0];
    List ans_top = [0, 0];
    List ans_bottom = [0, 0];
    //ヤコビで連立方程式の計算
    jacobi(A, right, ans_right);
    jacobi(A, left, ans_left);
    jacobi(A, top, ans_top);
    jacobi(A, bottom, ans_bottom);

    //絶対値を入れる
    double abs_right = math.sqrt(math.pow(ans_right[0], 2)
        + math.pow(ans_right[1], 2));
    double abs_left = math.sqrt(math.pow(ans_left[0], 2)
        + math.pow(ans_left[1], 2));
    double abs_top = math.sqrt(math.pow(ans_top[0], 2)
        + math.pow(ans_top[1], 2));
    double abs_bottom = math.sqrt(math.pow(ans_bottom[0], 2)
        + math.pow(ans_bottom[1], 2));

    if(angle == 90){
      _answer = [0, 0.5, 0, -0.5];
      return _answer;
    }
    if(angle == 270){
      _answer = [0, -0.5, 0, 0.5];
      return _answer;
    }


    if (math.tan(angle) >= 0){
      if (abs_right > abs_top) {
        _answer[0] = ans_top[0] / width;
        _answer[1] = ans_top[1] / height;
      } else {
        _answer[0] = ans_right[0] / width;
        _answer[1] = ans_right[1] / height;
      }

      if (abs_left > abs_bottom) {
        _answer[2] = ans_bottom[0] / width;
        _answer[3] = ans_bottom[1] / height;
      } else {
        _answer[2] = ans_left[0] / width;
        _answer[3] = ans_left[1] / height;
      }
    }else {
      if (abs_left > abs_top) {
        _answer[0] = ans_top[0] / width;
        _answer[1] = ans_top[1] / height;
      } else {
        _answer[0] = ans_left[0] / width;
        _answer[1] = ans_left[1] / height;
      }

      if (abs_right > abs_bottom) {
        _answer[2] = ans_bottom[0] / width;
        _answer[3] = ans_bottom[1] / height;
      } else {
        _answer[2] = ans_right[0] / width;
        _answer[3] = ans_right[1] / height;
      }
    }
    return _answer;
  }

  void jacobi(List<List<double>> a, List b, List x0) {
    final int N = 2;

    while (true) {
      List<double> x1 = [0, 0];
      bool finish = true;
      for (int i = 0; i < N; i++) {
        x1[i] = 0;
        for (int j = 0; j < N; j++) if (j != i) x1[i] += a[i][j] * x0[j];

        x1[i] = (b[i] - x1[i]) / a[i][i];
        if ((x1[i] - x0[i]).abs() > 0.0000000001) finish = false;
      }

      for (int i = 0; i < N; i++) {
        x0[i] = x1[i];
      }
      if (finish) return;
    }
  }

  List<SoundModel> soundPosition(
      double angle,
      double current_posi_x,
      double current_posi_y,
      List<Map<String, dynamic>> sounds_position,) {


  }
}
