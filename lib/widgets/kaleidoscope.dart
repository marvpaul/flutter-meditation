import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';

class Kaleidoscope extends StatefulWidget {
  final SessionPageViewModel viewModel;

  const Kaleidoscope({Key? key, required this.viewModel})
      : super(key: key);

  @override
  _KaleidoscopeState createState() => _KaleidoscopeState();
}

class _KaleidoscopeState extends State<Kaleidoscope>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  double delta = 0;
  FragmentShader? shader;
  ui.Image? image;
  String loadedImage = '';

  void loadImage() async {
    String imageToLoad = widget.viewModel.getLatestSessionParamaters().visualization??'Arctic'; 
    if(imageToLoad == ''){
      imageToLoad = 'Arctic'; 
    }
    if (loadedImage != imageToLoad) {
      final imageData =
          await rootBundle.load('assets/Mandalas/$imageToLoad.jpg');
      loadedImage = imageToLoad;
      image = await decodeImageFromList(imageData.buffer.asUint8List());
    }
  }

  void loadMyShader() async {
    print("Loading shader...");
    FragmentProgram program =
        await FragmentProgram.fromAsset('assets/shaders/myshader.frag');
        
    print("Shader loaded.");
    shader = program.fragmentShader();
    loadImage();

    if (!mounted) return; // check if the widget is still mounted
    setState(() {
      // trigger a repaint
    });

    timer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (!mounted) return; // check if the widget is still mounted
      setState(() {
        if (loadedImage != widget.viewModel.getLatestSessionParamaters().visualization) {
          loadImage();
        }
        delta += widget.viewModel.kaleidoscopeMultiplier * (1 / 33 * 5);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyShader();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null || image == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return CustomPaint(painter: MyFancyPainter(shader!, delta, image!));
    }
  }
}

class MyFancyPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final ui.Image image;
  Paint? paintObj;

  MyFancyPainter(FragmentShader fragmentShader, this.time, this.image)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    if (paintObj == null) {
      paintObj = Paint();
      shader.setFloat(0, size.width);
      shader.setFloat(1, size.height);
      shader.setFloat(2, time);
      shader.setImageSampler(0, image);

      paintObj!.shader = shader;
      //paintObj?.color = Colors.red;  
    }

    //canvas.drawRect(Offset.zero & size, paintObj!);
    canvas.drawRect(Offset.zero & size, paintObj!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
