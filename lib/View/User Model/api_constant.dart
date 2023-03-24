class APIConstant{


  ///Live url change befor production date-5 feb 23
  //static const String APIURL="https://api.creshsolutions.com";
  ///Test url
  //static const String APIURL="https://samadhantest.creshsolutions.com";
  static const String apiUrl="https://samadhanv3.creshsolutions.com";
  static const String houseList="$apiUrl/house";
  static const String houseNo="$apiUrl/house-no";
  static const String locationList="$apiUrl/location";
  static const String jcoLocationList="$apiUrl/drop-down/1?user_type=1&location=";
  static const String gcLocationList="$apiUrl/drop-down/1?user_type=2&location=";
  static const String accommodation="$apiUrl/accommodation";


}
class UT{
  static String loginStatus="False";
  static String mobileNo="Mobile";
  static String userId="UserID";
  static String appType="appType";
  static String battalion="battalion";
  static displayDateConverter(DateTime? selectedDate){
    String sendDateToApi = "${selectedDate!.day.toString().padLeft(2,"0")}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.year.toString().padLeft(2,'0')}";
    return sendDateToApi;
  }
}