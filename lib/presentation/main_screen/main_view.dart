import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/logic/cubit/home_data_cubit.dart';
import 'package:independet/presentation/resources/colors_manager.dart';
import 'package:independet/presentation/resources/routes_manager.dart';
import 'package:independet/presentation/resources/string_manager.dart';
import 'package:independet/presentation/resources/ui_constants_manager.dart';
import 'package:independet/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:independet/presentation/main_screen/compass.dart';

class MainView extends StatefulWidget {
  final MainData initialData;
  const MainView({Key? key, required this.initialData}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WidgetsBindingObserver {
  late String oldMsg;
  @override
  void initState() {
    oldMsg = widget.initialData.localMsg;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.white,
        floatingActionButton: _getFloatingActionButton(),
        body: BlocBuilder<HomeDataCubit, HomeDataState>(
            builder: (context, state) {
          if (state is HomeDataFail) {
            return const Center(
              child: Text(StringsManager.homeError),
            );
          }
          state as HomeDataFetched;
          oldMsg = state.dataObject.localMsg;
          late final String distanceString;
          double distanceDouble =
              double.parse((state.dataObject.distance).toStringAsFixed(1));
          if (distanceDouble > 1000) {
            distanceDouble /= 1000;
            distanceDouble = double.parse((distanceDouble).toStringAsFixed(1));
            distanceString = "${distanceDouble}km";
          } else {
            distanceString = "${distanceDouble}m";
          }
          return _getContentWidget(
            distanceString,
            state.dataObject.partnerMsg,
            state.dataObject.angle,
            state.dataObject.latitude,
            state.dataObject.longitude,
          );
        }));
  }

  Widget _getContentWidget(String distance, String msg, double angel,
      double latitude, double longitude) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  distance,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(msg,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
            AnimatedSwitcher(
                duration: UiConstantsManager.compassAngleAnimationDuration,
                child: Compass(angle: angel)),
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () async {
                Uri googleUrl = Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
                await launchUrl(googleUrl);
              },
              child: const Text(StringsManager.getLastLocation),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFloatingActionButton() {
    return FloatingActionButton(
        backgroundColor: ColorsManager.floatingActionButtonColor,
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.settingRoute,
            arguments: SettingViewArguments(oldMsg, context),
          );
        },
        child: const Icon(Icons.edit));
  }
}
