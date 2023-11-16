import 'dart:collection';
import 'dart:convert';
import "dart:core";
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/main.dart';
import 'package:plant_flutter/network/QueryString.dart';
import 'package:plant_flutter/utils/constants.dart';

class PlantApi {
  String? url;
  String? consumerKey;
  String? consumerSecret;
  bool? isHttps;

  PlantApi() {
    this.url = baseUrl + '/wp-json';
    this.consumerKey = ConsumerKey;
    this.consumerSecret = ConsumerSecret;

    if (this.url!.startsWith("https")) {
      this.isHttps = true;
    } else {
      this.isHttps = false;
    }
  }

  Uri? _getOAuthURL(String requestMethod, String endpoint) {
    var url = this.url! + endpoint;
    var containsQueryParams = url.contains("?");
    var token = "";
    var tokenSecret = "";

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if (this.isHttps == true) {
      return Uri.parse(url +
          (containsQueryParams == true
              ? "&consumer_key=" + this.consumerKey.validate() + "&consumer_secret=" + this.consumerSecret.validate()
              : "?consumer_key=" + this.consumerKey.validate() + "&consumer_secret=" + this.consumerSecret.validate()));
    } else {
      var rand = new Random();
      var codeUnits = new List.generate(10, (index) {
        return rand.nextInt(26) + 97;
      });

      var nonce = new String.fromCharCodes(codeUnits);
      int timestamp = new DateTime.now().millisecondsSinceEpoch ~/ 1000;

      var method = requestMethod;
      var parameters = "oauth_consumer_key=" +
          consumerKey! +
          "&oauth_nonce=" +
          nonce +
          "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
          timestamp.toString() +
          "&oauth_token=" +
          token +
          "&oauth_version=1.0&";

      if (containsQueryParams == true) {
        parameters = parameters + url.split("?")[1];
      } else {
        parameters = parameters.substring(0, parameters.length - 1);
      }

      Map<dynamic, dynamic> params = QueryString.parse(parameters);
      Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
      treeMap.addAll(params);

      String parameterString = "";

      for (var key in treeMap.keys) {
        parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
      }

      parameterString = parameterString.substring(0, parameterString.length - 1);

      var baseString = method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);

      var signingKey = consumerSecret! + "&" + tokenSecret;
      var hmacSha1 = new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
      var signature = hmacSha1.convert(utf8.encode(baseString));

      var finalSignature = base64Encode(signature.bytes);

      var requestUrl = "";

      if (containsQueryParams == true) {
        requestUrl = url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
      } else {
        requestUrl = url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
      }

      return Uri.parse(requestUrl);
    }
  }

  Map<String, String> _buildHeaderTokens({bool print = true}) {
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };

    if (userStore.isLoggedIn) {
      header.putIfAbsent('token', () => '${userStore.token}');
      header.putIfAbsent('id', () => '${userStore.userId}');
    }
    if (print) log(jsonEncode(header));
    return header;
  }

  Future<http.Response> getAsync(String endPoint, {requireToken = false, isFood = false}) async {
    Uri? url = this._getOAuthURL("GET", endPoint);
    //  log(url);

    if (url == null) throw 'Invalid URL';

    final response = await http.get(url, headers: _buildHeaderTokens());
    log('${response.statusCode} $url');
    log(response.body);
    return response;
  }

  Future<http.Response> postAsync(String endPoint, Map data, {requireToken = false, auth = false}) async {
    Uri? url = this._getOAuthURL("POST", endPoint);
    log(url);

    if (url == null) throw 'Invalid URL';
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
      HttpHeaders.authorizationHeader:  "Bearer ${userStore.token}"
    };

    var client = new http.Client();
    var response = await client.post(url, body: jsonEncode(data), headers: auth == true ? headers : _buildHeaderTokens());

    log(response.statusCode);
    log(jsonDecode(response.body));
    return response;
  }

  Future<http.Response> putAsync(String endPoint, Map data, {requireToken = false}) async {
    var url = this._getOAuthURL("POST", endPoint);
    log(url);

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };
    if (requireToken) {
      SharedPreferences pref = await getSharedPref();
      var header = {"token": "${pref.getString(sharedPref.apiToken)}", "id": "${pref.getInt(sharedPref.userId)}"};
      headers.addAll(header);
    }

    log(jsonEncode(headers));
    log(jsonEncode(data));

    var client = new http.Client();
    var response = await client.put(url!, body: jsonEncode(data), headers: headers);

    log(response.statusCode);
    log(jsonDecode(response.body));
    return response;
  }

  Future<http.Response> deleteAsync(String endPoint) async {
    Uri? url = this._getOAuthURL("DELETE", endPoint);
    log(url);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
    };
    var client = new http.Client();

    final response = await client.delete(url!, headers: headers);

    return response;
  }
}
