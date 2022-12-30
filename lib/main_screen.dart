import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'save_file_mobile_and_desktop.dart'
    if (dart.library.html) 'save_file_web.dart';
import 'package:http/http.dart' show get;

class MainScreen extends StatelessWidget {
  const MainScreen(
      {Key? key,
      required this.width,
      required this.height,
      required this.pageCount,
      required this.pageSize})
      : super(key: key);

  final String width;
  final String height;
  final String pageCount;
  final String pageSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyHomePage(
      title: 'SAMIR',
      Width: width,
      Height: height,
      PageCount: pageCount,
      PageSize: pageSize,
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.Width,
      required this.Height,
      required this.PageCount,
      required this.PageSize});

  final String title;
  final String Width;
  final String Height;
  final String PageCount;
  final String PageSize;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              "https://dummyimage.com/${widget.Width}x${widget.Height}",
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: _save,
              child: const Text(
                'Download Preview Image Here',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: _convertImageToPDF,
              child: const Text(
                'Convert image to PDF document',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    var response = await Dio().get(
        "https://dummyimage.com/${widget.Width}x${widget.Height}",
        options: Options(responseType: ResponseType.bytes));

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "Hello");
    print(result);
  }

  Future<void> _convertImageToPDF() async {
    //Create the PDF document
    PdfDocument document = PdfDocument();

    document.pageSettings.margins.all = 20;

    if (widget.PageSize == "A1") {
      document.pageSettings.size = PdfPageSize.a1;
    } else if (widget.PageSize == "A2") {
      document.pageSettings.size = PdfPageSize.a2;
    } else if (widget.PageSize == "A3") {
      document.pageSettings.size = PdfPageSize.a3;
    } else if (widget.PageSize == "A4") {
      document.pageSettings.size = PdfPageSize.a4;
    } else if (widget.PageSize == "A5") {
      document.pageSettings.size = PdfPageSize.a5;
    }

    print('Page Size : ${widget.PageSize}');

    // document.pageSettings.size = PdfPageSize.a3;
    // document.pageSettings.size = PdfPageSize.a4;

    //Add the page
    PdfPage page = document.pages.add();

    //load image from url.
    var url = "https://dummyimage.com/${widget.Width}x${widget.Height}";
    var response = await get(Uri.parse(url));
    var data = response.bodyBytes;

    //Create a bitmap object.
    PdfBitmap image = PdfBitmap(data);

    //Load the image from assest.
    // final PdfImage image = PdfBitmap(await _readImageData('23_image.png'));

    var defaultY = 0.0;
    var defaultX = 0.0;
    var defaultMargin = 10.0;

    // var actualImgWidth = image.width.toDouble();
    // var actualImgHeight = image.height.toDouble();

    print('Page Width:  ${widget.Width}');
    print('Page Height: ${widget.Height}');
    print('Page Count:  ${widget.PageCount}');

    var actualImgWidth = double.parse(widget.Width);
    var actualImgHeight = double.parse(widget.Height);
    var actualPageCount = double.parse(widget.PageCount);

    var actualPageWidth = page.size.width.toDouble();
    var actualPageHeight = page.size.height.toDouble();

    var xxx = actualImgWidth + defaultMargin;
    var capacityx = actualPageWidth / xxx;
    print('Capacity_width : $capacityx');

    var yyy = actualImgHeight + defaultMargin;
    var capacityY = actualPageHeight / yyy;
    print('Capacity_height : $capacityY');

    var printCountX, printCountY = 1;
    var imgHeightPrev = 0.0;
    var count = 0;

    try {
      for (printCountY = 1; printCountY < capacityY; printCountY++) {
        for (printCountX = 1; printCountX <= capacityx; printCountX++) {
          if (count++ < actualPageCount) {
            page.graphics.drawImage(
                image,
                Rect.fromLTWH(
                    defaultX, defaultY, actualImgWidth, actualImgHeight));
            var previous = defaultX;
            defaultX = actualImgWidth + previous + defaultMargin;
            // print('print pages :${count}');
          }
        }
        defaultX = 0.0;
        imgHeightPrev = defaultY;
        defaultY = actualImgHeight + imgHeightPrev + defaultMargin;
        // count = printCountX + printCountY;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return;
    }

/*
    //1
    page.graphics.drawImage(
        image,
        Rect.fromLTWH(default_x, default_y, image.width.toDouble(),
            image.height.toDouble()));

    //2
    page.graphics.drawImage(
        image,
        Rect.fromLTWH(x + default_margin, default_y, image.width.toDouble(),
            image.height.toDouble()));

    //3
    page.graphics.drawImage(
        image,
        Rect.fromLTWH(default_x, y + default_margin, image.width.toDouble(),
            image.height.toDouble()));
    //4
    page.graphics.drawImage(
        image,
        Rect.fromLTWH(x + default_margin, y + default_margin,
            image.width.toDouble(), image.height.toDouble()));

*/
    print('Image Height : ${image.height.toDouble().toString()}');
    print('Image Width :  ${image.width.toDouble().toString()}');

    print('Page Width: ${page.size.width.toString()}');
    print('Page Height: ${page.size.height.toString()}');

    //Save the document.
    List<int> bytes = await document.save();

    // Dispose the document.
    document.dispose();

    //Save the file and launch/download.
    SaveFile.saveAndLaunchFile(bytes, 'output.pdf');
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
