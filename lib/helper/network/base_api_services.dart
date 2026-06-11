

abstract class BaseApiServices{

  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url,dynamic data);
  Future<dynamic> getPostApiFormData(String url, Map<String, String> fields, Map<String, dynamic> files);
  Future<dynamic> getPutApiResponse(String url, dynamic data);
  Future<dynamic> getDeleteApiResponse(String url, Map<String, dynamic> data);



}