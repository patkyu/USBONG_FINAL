import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mighty_plant_admin/component/ExpandChartToLandScapeModeComponent.dart';
import 'package:mighty_plant_admin/component/HorizontalBarChart.dart';
import 'package:mighty_plant_admin/component/OrderCardWidget.dart';
import 'package:mighty_plant_admin/main.dart';
import 'package:mighty_plant_admin/models/DashboardResponse.dart';
import 'package:mighty_plant_admin/models/OrderResponse.dart';
import 'package:mighty_plant_admin/models/SummaryResponse.dart';
import 'package:mighty_plant_admin/network/rest_apis.dart';
import 'package:mighty_plant_admin/utils/AppColors.dart';
import 'package:mighty_plant_admin/utils/AppCommon.dart';
import 'package:mighty_plant_admin/utils/AppConstants.dart';
import 'package:mighty_plant_admin/utils/AppImages.dart';
import 'package:mighty_plant_admin/utils/AppWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  SummaryResponse? summaryResponse;

  DateTimeRange? picked = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime firstDayCurrentMonth = DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

  List<SaleReport> saleReportList = [];
  List<NewComment> newCommentList = [];
  List<SaleTotalData> topSaleTotalList = [];
  List<OrderTotal> orderSummaryTotalList = [];
  List<ProductsTotal> productSummaryTotalList = [];
  List<OrderTotal> customerTotalList = [];
  List<OrderResponse> newOrderList = [];
  List<SaleTotalData> orderTotalList = [];

  String date = 'Select date';
  String dateMin = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateMax = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String topDateMin = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String topDateMax = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String errorMsg = '';

  List<String> periodType = ['week', 'month', 'last_month', 'year'];

  String? selectPeriod = "week";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    dateMin = DateFormat('yyyy-MM-dd').format(firstDayCurrentMonth);
    date = "[ $dateMin to $dateMax ]";
    dashboardData(dateMin: dateMin, dateMax: dateMax);
  }

  Future<void> dashboardData({String? dateMin, String? dateMax}) async {
    appStore.setLoading(true);

    await getDashboard(dateMin: dateMin, dateMax: dateMax, period: selectPeriod).then((value) {
      Iterable newOrder = value['new_order'];
      newOrderList.addAll(newOrder.map((e) => OrderResponse.fromJson(e)).toList());

      Iterable customerTotal = value['customer_total'];
      customerTotalList.addAll(customerTotal.map((e) => OrderTotal.fromJson(e)).toList());

      Iterable saleReport = value['sale_report'];
      saleReportList.addAll(saleReport.map((e) => SaleReport.fromJson(e)).toList());

      Iterable comment = value['new_comment'];
      newCommentList.addAll(comment.map((e) => NewComment.fromJson(e)).toList());

      Iterable order = value['order_total'];
      orderSummaryTotalList.addAll(order.map((e) => OrderTotal.fromJson(e)).toList());

      Iterable product = value['products_total'];
      productSummaryTotalList.addAll(product.map((e) => ProductsTotal.fromJson(e)).toList());

      (value['top_sale_report'] as Iterable).forEach((element) {
        List<SaleTotalData> value = [];

        (element['totals'] as Map).entries.forEach((element) {
          value.add(SaleTotalData.fromJson(element.value)..key = element.key);
        });

        topSaleTotalList.addAll(value);
        setState(() {});
      });

      (value['sale_report'] as Iterable).forEach((element) {
        List<SaleTotalData> value = [];

        (element['totals'] as Map).entries.forEach((element) {
          value.add(SaleTotalData.fromJson(element.value)..key = element.key);
        });

        orderTotalList.addAll(value);
        setState(() {});
      });
    }).catchError((e) {
      errorMsg = e.toString();
      setState(() {});
    });

    appStore.setLoading(false);
  }

  void clearListApiCall() {
    saleReportList.clear();
    newCommentList.clear();
    topSaleTotalList.clear();
    orderSummaryTotalList.clear();
    productSummaryTotalList.clear();
    customerTotalList.clear();
    newOrderList.clear();
    orderTotalList.clear();
    dashboardData(dateMin: dateMin, dateMax: dateMax);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        titleWidget: Row(
          children: [
            cachedImage(app_logo, height: 50, width: 50, color: white),
            8.width,
            Text("lbl_dashboard".translate, style: boldTextStyle(color: white, size: 20)),
          ],
        ),
        elevation: 0,
        color: primaryColor,
        showBack: false,
        center: false,
      ),
      body: Stack(
        children: [
          Container(
            height: context.height(),
            width: context.width(),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${DateFormat.yMMMd().format(DateTime.now())}", style: secondaryTextStyle(size: 16)),
                          Text('${'lbl_Hello'.translate} ${getStringAsync(FIRST_NAME)} ${getStringAsync(LAST_NAME)}', style: boldTextStyle(size: 18)),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  if (saleReportList.validate().isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$date', style: secondaryTextStyle()),
                        Icon(Icons.date_range, color: appStore.iconColor, size: 20).onTap(() async {
                          picked = await showDateRangePicker(
                            firstDate: DateTime(1900),
                            initialDateRange: picked,
                            context: context,
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: appStore.isDarkModeOn
                                    ? ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(primary: primaryColor, onPrimary: Colors.white, surface: primaryColor, onSurface: Colors.white),
                                        dialogBackgroundColor: Theme.of(context).cardColor,
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.light(primary: primaryColor),
                                        dialogBackgroundColor: Theme.of(context).cardColor,
                                      ),
                                child: child.paddingAll(8),
                              );
                            },
                          );
                          if (picked != null) {
                            date = "[ ${DateFormat('dd-MM-yyyy').format(picked!.start)} to ${DateFormat('dd-MM-yyyy').format(picked!.end)} ]";
                            dateMin = DateFormat('yyyy-MM-dd').format(picked!.start);
                            dateMax = DateFormat('yyyy-MM-dd').format(picked!.end);
                            setState(() {});
                            clearListApiCall();
                          }
                        }),
                      ],
                    ),
                  16.height,
                  if (saleReportList.validate().isNotEmpty)
                    Container(
                      decoration: boxDecorationDefault(
                        borderRadius: radius(defaultRadius),
                        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                        color: context.cardColor,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('lbl_total_sale'.translate, style: boldTextStyle(size: 18), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                              16.width,
                            ],
                          ),
                          16.height,
                          Wrap(
                            runSpacing: 16,
                            spacing: 16,
                            children: [
                              cardWidget(context, orderName: "lbl_total_sale".translate, total: saleReportList.first.totalSales.validate().toInt(), color: Colors.teal, image: 'images/ic_sale.png'),
                              cardWidget(context, orderName: "lbl_net_sale".translate, total: saleReportList.first.netSales.validate().toInt(), color: Colors.pink, image: 'images/ic_sale.png'),
                              cardWidget(context,
                                  orderName: "lbl_average_sale".translate, total: saleReportList.first.averageSales.validate().toInt(), color: Colors.blue, image: 'images/ic_sale.png'),
                              cardWidget(context,
                                  orderName: "lbl_total_orders".translate,
                                  total: saleReportList.first.totalOrders.toString().validate().toInt(),
                                  color: Colors.deepOrange,
                                  image: 'images/ic_order.png'),
                              cardWidget(context,
                                  orderName: "lbl_total_items".translate, total: saleReportList.first.totalItems.toString().validate().toInt(), color: Colors.green, image: 'images/ic_item.png'),
                              cardWidget(context,
                                  orderName: "lbl_total_shipping".translate,
                                  total: saleReportList.first.totalShipping.toString().validate().toInt(),
                                  color: Colors.deepPurple,
                                  image: 'images/ic_shipping.png')
                            ],
                          ).center(),
                        ],
                      ),
                    ),
                  16.height.visible(saleReportList.validate().isNotEmpty),
                  if (orderTotalList.isNotEmpty)
                    Container(
                      decoration: boxDecorationDefault(
                        borderRadius: radius(defaultRadius),
                        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                        color: context.cardColor,
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.zero,
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('lbl_sale_report'.translate, style: boldTextStyle(size: 18), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                              IconButton(
                                icon: Icon(
                                  Icons.crop_rotate_rounded,
                                ),
                                onPressed: () {
                                  ExpandChartToLandScapeModeComponent(orderTotalList).launch(context);
                                },
                              )
                            ],
                          ),
                          8.height,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: HorizontalBarChart(orderTotalList).withSize(
                              width: context.width(),
                              height: 350,
                            ),
                          ),
                        ],
                      ),
                    ),
                  16.height.visible(orderTotalList.isNotEmpty),
                  if (topSaleTotalList.isNotEmpty)
                    Container(
                      decoration: boxDecorationDefault(
                        borderRadius: radius(defaultRadius),
                        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                        color: context.cardColor,
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.zero,
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('lbl_top_sellers_report'.translate, style: boldTextStyle(size: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                              IconButton(
                                icon: Icon(Icons.crop_rotate_rounded),
                                onPressed: () {
                                  ExpandChartToLandScapeModeComponent(topSaleTotalList).launch(context);
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: 150,
                            decoration: BoxDecoration(borderRadius: radius(8), color: Colors.grey.withOpacity(0.1)),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            child: DropdownButton<String>(
                              value: selectPeriod,
                              dropdownColor: appStore.scaffoldBackground,
                              isExpanded: true,
                              underline: SizedBox(),
                              items: periodType.map((e) => DropdownMenuItem(value: e, child: Text(e, style: primaryTextStyle()))).toList(),
                              onChanged: (String? value) {
                                selectPeriod = value;
                                setState(() {});
                                clearListApiCall();
                              },
                            ),
                          ),
                          8.height,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: HorizontalBarChart(topSaleTotalList, chartType: ChartType.CHART3).withSize(width: context.width(), height: 350),
                          ),
                        ],
                      ),
                    ),
                  16.height.visible(topSaleTotalList.isNotEmpty),
                  if (orderSummaryTotalList.isNotEmpty)
                    Container(
                      decoration: boxDecorationDefault(
                        borderRadius: radius(defaultRadius),
                        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                        color: context.cardColor,
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('lbl_order_total'.translate, style: boldTextStyle(size: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                          16.height,
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: orderSummaryTotalList.map(
                              (e) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.name.validate(), style: primaryTextStyle(size: 16, color: statusColor(e.name!.toLowerCase())), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                                    Text(e.total.toString(), style: primaryTextStyle(size: 16, color: statusColor(e.name!.toLowerCase()))),
                                  ],
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  16.height.visible(orderSummaryTotalList.isNotEmpty),
                  if (productSummaryTotalList.validate().isNotEmpty)
                    Container(
                      decoration: boxDecorationDefault(
                        borderRadius: radius(defaultRadius),
                        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                        color: context.cardColor,
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('lbl_product_total'.translate, style: boldTextStyle(size: 18)),
                          16.height,
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: productSummaryTotalList.map(
                              (e) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.name.validate(), style: primaryTextStyle(size: 16), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                                    Text(e.total.toString(), style: primaryTextStyle(size: 16)),
                                  ],
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  16.height.visible(productSummaryTotalList.validate().isNotEmpty),
                  if (customerTotalList.validate().isNotEmpty)
                    Container(
                      decoration: boxDecorationDefault(
                        borderRadius: radius(defaultRadius),
                        boxShadow: defaultBoxShadow(blurRadius: 24, spreadRadius: 2, shadowColor: appStore.isDarkModeOn ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                        color: context.cardColor,
                      ),
                      padding: EdgeInsets.all(16),
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('lbl_customer_total'.translate, style: boldTextStyle(size: 18)),
                          16.height,
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: customerTotalList.map(
                              (e) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.name.validate(), style: primaryTextStyle(size: 16), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                                    Text(e.total.toString(), style: primaryTextStyle(size: 16)),
                                  ],
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  16.height.visible(customerTotalList.validate().isNotEmpty),
                  if (newOrderList.isNotEmpty)
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('lbl_new_order'.translate, style: boldTextStyle(size: 18)),
                          16.height,
                          ListView.separated(
                            separatorBuilder: (context, i) => Divider(height: 0),
                            itemCount: newOrderList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              OrderResponse data = newOrderList[i];
                              return OrderCardWidget(
                                orderResponse: data,
                                onUpdate: () {
                                  setState(() {});
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  16.height.visible(newOrderList.isNotEmpty),
                  if (newCommentList.isNotEmpty)
                    Container(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('lbl_new_comment'.translate, style: boldTextStyle(size: 18)),
                          16.height,
                          ListView.separated(
                            separatorBuilder: (context, i) => Divider(height: 16),
                            itemCount: newCommentList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              NewComment data = newCommentList[i];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  cachedImage(getStringAsync(AVATAR), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(80),
                                  8.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(parseHtmlString('${data.commentAuthor.capitalizeFirstLetter()}'), style: boldTextStyle()),
                                      6.height,
                                      Text(DateFormat.yMMMd().format(DateTime.parse(data.commentDate!)), style: secondaryTextStyle(size: 14)),
                                      8.height,
                                      Text(parseHtmlString('${data.commentContent}'), style: primaryTextStyle(size: 14)),
                                      8.height,
                                    ],
                                  ).expand(),
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ).visible(!appStore.isLoading),
          Observer(builder: (_) => loading().center().visible(appStore.isLoading)),
          Text(errorMsg).center().visible(errorMsg.isNotEmpty)
        ],
      ),
    );
  }
}
