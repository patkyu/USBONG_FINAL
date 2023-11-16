import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_plant_admin/component/CustomerItemWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/CustomerResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/component/AddCustomerDialog.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class AllCustomerListScreen extends StatefulWidget {
  static String tag = '/AllCustomerListScreen';

  @override
  AllCustomerListScreenState createState() => AllCustomerListScreenState();
}

class AllCustomerListScreenState extends State<AllCustomerListScreen> {
  bool mIsLastPage = false;
  int page = 1;
  List<CustomerResponse> customerList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getAllCustomerList();
    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (!mIsLastPage) {
          page++;
          appStore.setLoading(true);
          getAllCustomerList();
          setState(() {});
        }
      }
    });
  }

  Future<void> getAllCustomerList() async {
    appStore.setLoading(true);

    await getAllCustomer(page: page).then((res) async {
      if (page == 1) customerList.clear();

      customerList.addAll(res);
      mIsLastPage = res.length != perPage;
      customerList.sort((a, b) => a.username!.compareTo(b.username!));
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget("lbl_All_Customer".translate, showBack: true, color: primaryColor, textColor: white),
        body: Stack(
          children: [
            if (customerList.isNotEmpty)
              ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 70 ),
                itemCount: customerList.length,
                itemBuilder: (context, i) {
                  CustomerResponse data = customerList[i];
                  return CustomerItemWidget(
                    data: data,
                    onUpdate: () {
                      customerList.sort((a, b) => a.username!.compareTo(b.username!));
                      setState(() {});
                    },
                    onDelete: (id) {
                      toast('successfully_deleted'.translate);
                      customerList.removeWhere((element) => element.id == id);
                      setState(() {});
                    },
                  ).paddingAll(8);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            NoDataFound(
                title: 'no_customer_available'.translate,
                onPressed: () {
                  finish(context);
                }).visible(!appStore.isLoading && customerList.isEmpty),
            Observer(builder: (_) => loading().visible(appStore.isLoading))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: '1',
          elevation: 5,
          backgroundColor: primaryColor,
          onPressed: () async {
            showInDialog(context,backgroundColor: context.cardColor,builder: (p0) {
              return AddCustomerDialog(onUpdate: (){
                getAllCustomerList();
              });
            },);
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
