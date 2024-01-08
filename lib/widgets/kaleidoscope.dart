/// {@category Widget}
library kaleidoscope;
import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meditation/session/view_model/session_page_view_model.dart';
/// This class is responsible for creating our kaleoidoscope visualization during meditation
/// 
/// We load an image from the asset folder and bind it to a small fragment shader which 
/// manipulates the UV coordinates for the binded texture in order
/// to create a mandala effect. 
/// Furthermore we expose a variable to animate the kaleidoscope and make it reactive to 
/// the actual breathing cycle within our meditation. 
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
  double fade = 1;
  FragmentShader? shader;
  ui.Image? image, prevImage;
  String loadedImage = '';

  /// This method loads an image from the asset folder under path assets/Mandalas/
  /// We implemented the option to fade between two visualizations / images. Therefor we always store a copy of 
  /// the actually loaded image in prevImage before loading a new image in order to smoothly fade between them 
  /// whenever we load a new image.
  void loadImage() async {
    String imageToLoad = widget.viewModel.getLatestSessionParameters().visualization??'Arctic'; 
    if(imageToLoad == ''){
      imageToLoad = 'Arctic'; 
    }
    if (loadedImage != imageToLoad) {
      final imageData =
          await rootBundle.load('assets/Mandalas/$imageToLoad.jpg');
      loadedImage = imageToLoad;
      if(prevImage != null){
        prevImage?.dispose();
        fade = 0; 
        prevImage = image?.clone(); 
        image = await decodeImageFromList(imageData.buffer.asUint8List());
      } else {
        image = await decodeImageFromList(imageData.buffer.asUint8List());
        prevImage = image?.clone(); 

      }
    }
  }

  /// This function loads a custom fragment shader from our assets: assets/shaders/myshader.frag
  /// loads an image and initialize an update loop in order to smoothly animate our kaleidoscope animation. 
  /// Note: We execute our update loop every 33ms (30 FPS) and call the setState method of our widget to trigger a repaint.
  /// This repaint finally triggers the paint method from out KaleidoscopePainter to render the shader into our canvas which 
  /// lives inside the widget tree. 
  void loadMyShader() async {
    FragmentProgram program =
        await FragmentProgram.fromAsset('assets/shaders/myshader.frag');
    shader = program.fragmentShader();
    loadImage();

    if (!mounted) return; 
    setState(() {
      // trigger a repaint
    });

    timer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (!mounted || !widget.viewModel.running) return;
      setState(() {
        if (loadedImage != widget.viewModel.getLatestSessionParameters().visualization) {
          loadImage();
        }
        delta += widget.viewModel.kaleidoscopeMultiplier * (1 / 33 * 5);
        fade += 1 / 33;
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
      return CustomPaint(painter: KaleidoscopePainter(shader!, delta, fade, image!, prevImage!));
    }
  }
}

class KaleidoscopePainter extends CustomPainter {
  final FragmentShader shader;
  final double time, fade;
  final ui.Image image, prevImage;
  Paint? paintObj;

  KaleidoscopePainter(FragmentShader fragmentShader, this.time, this.fade, this.image, this.prevImage)
      : shader = fragmentShader;

  /// Method to render our kaleidoscope
  /// We first bind all important variables to our shader: 
  /// - size of our canvas
  /// - a time variable to control the animation / movement
  /// - a fade parameter to smoothly fade between two loaded images
  /// - our two images which we want to display
  /// 
  /// We inherit from class CustomPainter which allows us to draw to a canvas. 
  /// The trick here is to draw a simple reactangle which fills the hole
  /// canvas and bind our custom shader to the paint object so that the reactangle
  /// will be filled with the colors provided by our fragment shader. 
  @override
  void paint(Canvas canvas, Size size) {
    if (paintObj == null) {
      paintObj = Paint();
      shader.setFloat(0, size.width);
      shader.setFloat(1, size.height);
      shader.setFloat(2, time);
      shader.setFloat(3, fade);
      shader.setImageSampler(0, image);
      shader.setImageSampler(1, prevImage);

      paintObj!.shader = shader;
    }
    canvas.drawRect(Offset.zero & size, paintObj!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
