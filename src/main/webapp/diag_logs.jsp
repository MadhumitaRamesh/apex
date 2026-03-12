<%@ page import="java.util.*, com.google.firebase.database.*" %>
<%
    DatabaseReference ref = FirebaseDatabase.getInstance().getReference("activities");
    ref.addListenerForSingleValueEvent(new ValueEventListener() {
        public void onDataChange(DataSnapshot snapshot) {
            System.out.println("DEBUG: Activities Count: " + snapshot.getChildrenCount());
            for (DataSnapshot ds : snapshot.getChildren()) {
                System.out.println("DEBUG: Activity: " + ds.getValue());
            }
        }
        public void onCancelled(DatabaseError error) {
            System.out.println("DEBUG: Activities Cancelled: " + error.getMessage());
        }
    });
%>
Dumping activities to log. Check catalina.out.
