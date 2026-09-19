abstract class AdminRepository {
  Future<Map<String, dynamic>> getStats();
  Future<List<Map<String, dynamic>>> listUsers();
  Future<void> toggleUserBan(String userId);
  Future<List<Map<String, dynamic>>> listReports();
  Future<void> handleReport(String reportId, String status);
  Future<List<Map<String, dynamic>>> listActiveRooms();
  Future<void> closeRoom(String roomId);
  Future<List<Map<String, dynamic>>> listVideos();
  Future<void> deleteVideo(String videoId);
  Future<void> sendGlobalNotification(String title, String body);
}
