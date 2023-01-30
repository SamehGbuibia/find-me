import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:independet/app/app_prefs.dart';
import 'package:independet/domain/models/models.dart';
import 'package:independet/logic/bloc/background_service_switch_bloc.dart';
import 'package:independet/logic/cubit/home_data_cubit.dart';
import 'package:independet/logic/cubit/is_id_exist_cubit.dart';
import 'package:independet/presentation/resources/colors_manager.dart';
import 'package:independet/presentation/resources/routes_manager.dart';
import 'package:independet/presentation/resources/string_manager.dart';
import 'package:independet/presentation/resources/values_manager.dart';

import '../../app/di.dart';

// ignore: must_be_immutable
class SettingView extends StatefulWidget {
  final String msg;
  final BuildContext? ctx;
  const SettingView({Key? key, required this.msg, required this.ctx})
      : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late final TextEditingController msgController;
  late final TextEditingController idController;
  late final PhoneID _phoneID;
  @override
  void initState() {
    _phoneID = instance<PhoneID>();
    msgController = TextEditingController(text: widget.msg);
    idController = TextEditingController(text: PhoneID.partnerID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocProvider(
            create: (context) => IsIdExistCubit(),
            child: BlocConsumer<IsIdExistCubit, IsIdExistState>(
              listener: (context, state) async {
                if (state is IdExist) {
                  PhoneID.partnerID = idController.text;
                  if (widget.ctx == null) {
                    final AppPreferences appPreferences =
                        instance<AppPreferences>();
                    await appPreferences.setData(MainData(
                        latitude: 0,
                        longitude: 0,
                        distance: 0,
                        angle: 0,
                        partnerMsg: "",
                        localMsg: msgController.text));
                  }
                  // ignore: use_build_context_synchronously
                  _navigateToMain(context);
                } else if (state is IdNotExist) {
                  _showMyDialog(context, StringsManager.wrongId, () {});
                } else if (state is MaximumTriesExceededState) {
                  _showMyDialog(context, StringsManager.reachMaxwrongId,
                      () => Navigator.pop(context));
                }
              },
              builder: (context, state) => IconButton(
                  onPressed: () async {
                    if (widget.ctx != null) {
                      BlocProvider.of<HomeDataCubit>(widget.ctx!)
                          .setMsg(msgController.text);
                    }
                    BlocProvider.of<IsIdExistCubit>(context)
                        .requestIsIdExist(idController.text);
                  },
                  icon: const Icon(Icons.check)),
            ),
          )
        ],
        title: const Text(StringsManager.settingPage),
      ),
      body: _getContentWidget(),
    );
  }

  void _navigateToMain(BuildContext context) {
    if (widget.ctx == null) {
      Navigator.pushReplacementNamed(context, Routes.splashRoute);
    } else {
      Navigator.pop(context);
    }
  }

  void _showMyDialog(BuildContext context, String msg, Function fun) {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Container(
                height: AppSize.s190,
                width: AppSize.s190,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s16)),
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          fun();
                        },
                        child: const Text("ok"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //private functions
  Widget _getContentWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                StringsManager.idTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SelectableText(
                _phoneID.id,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              _getSeparatorWidget(),
              Text(
                StringsManager.partnerIdTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: idController,
                cursorColor: ColorsManager.lightPrimary,
                decoration:
                    const InputDecoration(hintText: StringsManager.idHint),
              ),
              _getSeparatorWidget(),
              Text(
                StringsManager.editMsgTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: msgController,
                onChanged: (s) {
                  setState(() {});
                },
                cursorColor: ColorsManager.lightPrimary,
                // decoration: Theme.of(context).inputDecorationTheme,
              ),
              _getSeparatorWidget(),
              _getPreviewWidget(),
              _getSeparatorWidget(),
              _getServiceButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSeparatorWidget() => const SizedBox(height: 20);

  Widget _getPreviewWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              StringsManager.preview,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Text(
          StringsManager.tenkm,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(msgController.text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }

  Widget _getServiceButton() {
    return BlocProvider(
      create: (context) => BackgroundServiceSwitchBloc(),
      child: BlocBuilder<BackgroundServiceSwitchBloc,
          BackgroundServiceSwitchState>(
        builder: (context, state) {
          return ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
            child: Text(state.text),
            onPressed: () {
              if (state is BackgroundServiceSwitchedOffState) {
                BlocProvider.of<BackgroundServiceSwitchBloc>(context)
                    .add(BackgroundServiceSwitchOnEvent());
              } else if (state is BackgroundServiceSwitchedOnState) {
                BlocProvider.of<BackgroundServiceSwitchBloc>(context)
                    .add(BackgroundServiceSwitchOffEvent());
              }
            },
          );
        },
      ),
    );
  }
}
