class APIConstant{


  static const String APIURL="https://api.creshsolutions.com";
  static const String houseList="$APIURL/house";
  static const String houseNo="$APIURL/house-no";
  static const String locationList="$APIURL/location";
  static const String accommodation="$APIURL/accommodation";

}
class UT{
  static String loginStatus="False";
  static String mobileNo="Mobile";
  static String userId="UserID";
  static String appType="";
  static displayDateConverter(DateTime? selectedDate){
    String sendDateToApi = "${selectedDate!.day.toString().padLeft(2,"0")}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.year.toString().padLeft(2,'0')}";
    return sendDateToApi;
  }
}