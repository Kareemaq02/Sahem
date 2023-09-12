class TeamMember {
  TeamMember(this.intId, this.strName, this.blnIsLeader);
  int intId;
  String strName;
  bool blnIsLeader;

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      json['intId'] as int,
      '${json['strFirstName']} ${json['strLastName']}',
      json['isLeader'] as bool,
    );
  }
}
