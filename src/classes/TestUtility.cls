public class TestUtility {
    static Integer s_num = 1;

    public static String getFakeId(Schema.SObjectType sObjectType)
    {
      String result = String.valueOf(s_num++);
      return sObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }
}