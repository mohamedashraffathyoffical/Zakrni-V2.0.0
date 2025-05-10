import 'package:flutter/material.dart';
import '../widgets/app_icon_widget.dart';

class IconDemoPage extends StatelessWidget {
  const IconDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Size Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity), // To center the column
              const Text(
                'Fixed Size Icons',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Row of fixed-size icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  AppIconWidget(size: 50),
                  AppIconWidget(size: 80),
                  AppIconWidget(size: 120),
                ],
              ),
              
              const SizedBox(height: 40),
              const Text(
                'Responsive Icon (30% of screen width)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Responsive icon that adapts to screen size
              const ResponsiveAppIconWidget(
                widthFactor: 0.3,
                maxSize: 200,
              ),
              
              const SizedBox(height: 40),
              const Text(
                'Responsive Icon (50% of screen width)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Larger responsive icon
              const ResponsiveAppIconWidget(
                widthFactor: 0.5,
                maxSize: 300,
              ),
              
              const SizedBox(height: 40),
              const Text(
                'Different BoxFit Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Different BoxFit examples
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: const [
                  _BoxFitExample(BoxFit.contain, 'contain'),
                  _BoxFitExample(BoxFit.cover, 'cover'),
                  _BoxFitExample(BoxFit.fill, 'fill'),
                  _BoxFitExample(BoxFit.fitWidth, 'fitWidth'),
                  _BoxFitExample(BoxFit.fitHeight, 'fitHeight'),
                ],
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget to demonstrate different BoxFit options
class _BoxFitExample extends StatelessWidget {
  final BoxFit fit;
  final String label;
  
  const _BoxFitExample(this.fit, this.label);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Image.asset(
            'assets/imges/icon.png',
            fit: fit,
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
