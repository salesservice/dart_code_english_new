import 'package:flutter/material.dart';
import 'package:flutter_isell_new/controller/itemdeatails_controller.dart';
import 'package:flutter_isell_new/core/constants/sellx_colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ElektronikkDetailEssensiell {
  final String title;
  final String data;

  ElektronikkDetailEssensiell(this.title, this.data);
}

// ignore: must_be_immutable
class ElektronikkdataList extends StatelessWidget {
  ItemDetailsControllerImp controller = Get.put(ItemDetailsControllerImp());
  ElektronikkdataList({super.key});

  @override
  Widget build(BuildContext context) {
    String itempris =
        NumberFormat.decimalPattern().format(controller.itemsModel.itemPris);

    final List<ElektronikkDetailEssensiell> allData = [
      ElektronikkDetailEssensiell('Pris', itempris),
      ElektronikkDetailEssensiell(
          'Tilstand', "${controller.itemsModel.itemTistand}"),
      ElektronikkDetailEssensiell(
          'Merke', "${controller.itemsModel.itemMerke}"),
      ElektronikkDetailEssensiell(
          'Varen er', "${controller.itemsModel.salgLeie}"),
    ];

    final List<ElektronikkDetailEssensiell> essensielleData =
        allData.where((data) => data.data.isNotEmpty).toList();

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 4, right: 4),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        itemCount: essensielleData.length,
        itemBuilder: (context, index) {
          final ElektronikkDetailEssensiell data = essensielleData[index];
          final Color tileColor = index.isEven
              ? Myisellcolors.home
              : Myisellcolors.appbar; // Change colors here

          return _buildCarDetailTile(data, tileColor);
        },
      ),
    );
  }

  Widget _buildCarDetailTile(
      ElektronikkDetailEssensiell essensielleData, Color tileColor) {
    return essensielleData.data.isNotEmpty
        ? Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            color: tileColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  essensielleData.title,
                  style: GoogleFonts.roboto(
                      color: Myisellcolors.hvit, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  essensielleData.data,
                  style: GoogleFonts.roboto(
                      color: Myisellcolors.hvit, fontSize: 16),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
