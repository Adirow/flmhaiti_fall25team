import 'package:flmhaiti_fall25team/supabase/supabase_config.dart';

class SupabaseUtils {
  static Future<String> getCurrentUserId() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.id;
  }

  static Future<String> getCurrentClinicId() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await SupabaseConfig.client
        .from('users')
        .select('clinic_id')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null || response['clinic_id'] == null) {
      throw Exception('No clinic_id found for current user');
    }

    return response['clinic_id'] as String;
  }
}
