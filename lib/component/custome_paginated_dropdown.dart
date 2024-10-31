import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'custome_textformfield.dart';
import 'empty_information_widget.dart';

class CustomPaginatedDropDown extends StatefulWidget {
  final Future<void>? refresh;
  final OverlayPortalController tooltipController;
  final LayerLink link;
  final Function(OverlayPortalController) setActiveController;
  final ScrollController scrollController;
  final List<Map<String, dynamic>> dropDownMenuItemList;
  final bool hasPage;
  final String dropDownMenuItemDataKey;
  final String? hintText;
  final String? labelText;
  final bool? isValidate;
  final String? validatorText;
  final TextEditingController searchTextController;
  final bool? searchLoading;
  final TextEditingController? dropdownItemSelectionController;
  final VoidCallback? searchOnTap;
  final Color? filledColor;
  final Color? borderColor;
  final VoidCallback? otherComponentIsDependendOnThis;
  const CustomPaginatedDropDown({
    super.key,
    this.refresh,
    required this.tooltipController,
    required this.link,
    required this.setActiveController,
    required this.scrollController,
    required this.dropDownMenuItemList,
    required this.hasPage,
    required this.dropDownMenuItemDataKey,
    this.hintText,
    this.labelText,
    this.isValidate,
    this.validatorText,
    this.filledColor,
    this.borderColor,
    required this.searchTextController,
    this.dropdownItemSelectionController,
    this.searchOnTap,
    this.otherComponentIsDependendOnThis,
    this.searchLoading,
  });

  @override
  State<StatefulWidget> createState() => CustomPaginatedDropDownState();
}

class CustomPaginatedDropDownState extends State<CustomPaginatedDropDown> {
  double? _buttonWidth;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: widget.link,
      child: OverlayPortal(
          controller: widget.tooltipController,
          overlayChildBuilder: (BuildContext context) {
            return CompositedTransformFollower(
              link: widget.link,
              targetAnchor: Alignment.bottomLeft,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: MenuWidget(
                  tooltipController: widget.tooltipController,
                  width: _buttonWidth,
                  searchLoading: widget.searchLoading!,
                  scrollController: widget.scrollController,
                  hasPage: widget.hasPage,
                  dropDownMenuItemList: widget.dropDownMenuItemList,
                  dropDownMenuItemDataKey: widget.dropDownMenuItemDataKey,
                  hintText: widget.hintText ?? "",
                  searchTextController: widget.searchTextController,
                  searchOnTap: widget.searchOnTap,
                  itemSelectedController:
                      widget.dropdownItemSelectionController,
                  otherComponentIsDependendOnThis:
                      widget.otherComponentIsDependendOnThis,
                ),
              ),
            );
          },
          child: CustomeTextFormField(
            readOnly: true,
            onTap: onTap,
            controller: widget.dropdownItemSelectionController,
            hintText: widget.hintText,
            labelText: widget.labelText,
            validatorText: widget.validatorText,
            suffixIcon: Transform.rotate(
              angle: -(math.pi / 2.0),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 12,
              ),
            ),
          )),
    );
  }

  void onTap() {
    _buttonWidth = context.size?.width;
    // Set the active controller before toggling the overlay.
    widget.setActiveController(widget.tooltipController);
    widget.refresh;

    widget.tooltipController.toggle();
  }
}

// class ButtonWidget extends StatelessWidget {
//   const ButtonWidget({
//     super.key,
//     this.height = 48,
//     this.width,
//     this.onTap,
//     this.child,
//   });

//   final double? height;
//   final double? width;
//   final VoidCallback? onTap;
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: Material(
//         // color: Colors.white,
//         color: Colors.grey.shade200,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: const BorderSide(color: Colors.black12),
//         ),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(10),
//           child: Center(
//             child: child ?? const SizedBox(),
//           ),
//         ),
//       ),
//     );
//   }
// }

class MenuWidget extends StatelessWidget {
  final OverlayPortalController tooltipController;
  final ScrollController scrollController;
  final List<Map<String, dynamic>> dropDownMenuItemList;
  final bool hasPage;
  final String dropDownMenuItemDataKey;
  final String hintText;
  final TextEditingController searchTextController;
  final VoidCallback? searchOnTap;
  final bool searchLoading;
  final VoidCallback? otherComponentIsDependendOnThis;
  final TextEditingController? itemSelectedController;

  const MenuWidget({
    super.key,
    required this.tooltipController,
    this.width,
    required this.scrollController,
    required this.dropDownMenuItemList,
    required this.hasPage,
    required this.dropDownMenuItemDataKey,
    required this.hintText,
    required this.searchTextController,
    this.searchOnTap,
    required this.searchLoading,
    this.otherComponentIsDependendOnThis,
    this.itemSelectedController,
  });

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      height: 150,
      decoration: ShapeDecoration(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.5,
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 32,
            offset: Offset(0, 20),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(children: [
          CustomeTextFormField(
            controller: searchTextController,
            hintText: "Search",
            textInputAction: TextInputAction.done,
            suffixIcon: InkWell(
              onTap: searchOnTap,
              child: const Icon(Icons.search_rounded),
            ),
          ),
          Obx(() {
            if (searchLoading) {
              return Expanded(
                child: const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            } else if (dropDownMenuItemList.isEmpty) {
              return Expanded(
                child: const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: EmptyInformationWidget(title: "No data found"),
                    )),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  itemCount: hasPage
                      ? dropDownMenuItemList.length + 1
                      : dropDownMenuItemList.length,
                  itemBuilder: (context, index) {
                    if (index == dropDownMenuItemList.length) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.only(bottom: 2.0),
                        child: CircularProgressIndicator.adaptive(),
                      ));
                    }
                    var item = dropDownMenuItemList[index];
                    return InkWell(
                      onTap: () {
                        itemSelectedController != null
                            ? itemSelectedController!.text =
                                item[dropDownMenuItemDataKey].toString()
                            : null;
                        if (otherComponentIsDependendOnThis != null) {
                          otherComponentIsDependendOnThis!();
                        }
                        tooltipController.hide();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12.0),
                        child: Text(
                          item[dropDownMenuItemDataKey].toString(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          })
        ]),
      ),
    );
  }
}
