import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class DescriptionScreen extends StatefulWidget {
  DescriptionScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  List<Asset> images = <Asset>[];
  // ignore: unused_field
  String _error = 'No Error Dectected';
  final _formKey = GlobalKey<FormState>();
  bool _load = false;

  Widget buildGridView() {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: "Gallery",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
          selectionLimitReachedText:
              'Selection full. You can only select up to 10 images',
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  final validator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    Widget loadingIndicator = _load
        ? new Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          )
        : new Container();

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: _buildColumn(args),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }

  Widget _buildColumn(ScreenArguments args) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopContainer(args),
          _buildBottomContainer(),
        ],
      );

  Widget _buildTopContainer(ScreenArguments args) => Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Incident Description',
                  style: DefaultTextTheme.headline2,
                ),
                Text(
                  'Please provide the specific details of the incident',
                  style: DefaultTextTheme.subtitle1,
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: CustomIcons.siren,
                  validator: validator,
                  label: 'Incident Type',
                  onSaved: (val) {},
                  isReadOnly: true,
                  initialValue: args.incidentType,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: CustomIcons.description,
                  validator: validator,
                  label: 'Description',
                  onSaved: (val) {},
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Text(
                  'Attach images of the incident (Optional)',
                  style: TextStyle(color: Colors.grey),
                ),
                OutlinedButton(
                  onPressed: loadAssets,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.plus,
                        color: primaryColor,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Attach',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: buildGridView(),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildBottomContainer() => SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 100,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_left,
                        color: primaryColor,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/reporter/home/report/location',
                      arguments: ScreenArguments(),
                    );
                  },
                  child: Text('Continue'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(accentColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
