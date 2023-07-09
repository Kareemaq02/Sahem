import 'package:account/API/view_complaint_request.dart';
import 'package:flutter/material.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final List<ComplaintModel> complaints;

  ComplaintDetailsScreen({required this.complaints});

  @override
  _ComplaintViewState createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintDetailsScreen> {


  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    ComplaintModel complaint = widget.complaints.first;
   
  List<String> getImageUrls() {
  List<String> imageUrls = [];
  for (var media in complaint.lstMedia) {
    imageUrls.add(media); // Add the media (URL) to the list
  }
  return imageUrls;
}


  List<String> imageUrls = getImageUrls();

    return SafeArea(
      top: true,
      child: Align(
        alignment: AlignmentDirectional(0, 0),
        child: 
        
        Container(
          width: 280,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey,
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
               ElevatedButton(
              onPressed: () {
               
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Go Back'),
            ),
              Container(
                height: 180,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildImageCard(imageUrls[index]);
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageUrls.length, (index) {
                          return _buildImageIndicator(index);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              _buildDetailsContainer(
                complaintId: complaint.intId.toString(),
                complaintType: complaint.strComplaintTypeEn.toString(),
                timeCreated: complaint.dtmDateCreated.toString(),
                timeFinished: complaint.dtmDateFinished.toString(),
                status: "Resolved",
                address: "123 Main Street, City",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 2,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildImageIndicator(int index) {
    Color dotColor =
        index == selectedIndex ? Colors.black : Colors.grey.shade400;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: CircleAvatar(
        radius: 6,
        backgroundColor: dotColor,
      ),
    );
  }

  Widget _buildDetailsContainer({
    String complaintId="",
    String complaintType="",
    String timeCreated="",
    String timeFinished="",
    String status="",
    String address="",
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Complaint ID", complaintId),
              SizedBox(height: 8),
              _buildDetailRow("Complaint Type", complaintType),
              SizedBox(height: 8),
              _buildDetailRow("Time Created", timeCreated),
              SizedBox(height: 8),
              _buildDetailRow("Time Finished", timeFinished),
              SizedBox(height: 8),
              _buildDetailRow("Status", status),
              SizedBox(height: 8),
              _buildDetailRow("Address", address),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
