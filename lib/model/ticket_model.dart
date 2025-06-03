
class Ticket {
  final String eventId; 
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final int ticketCount;
  final double amountPaid;
  final String barcode;

  Ticket({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.ticketCount,
    required this.amountPaid,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId, 
      'eventName': eventName,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'eventLocation': eventLocation,
      'ticketCount': ticketCount,
      'amountPaid': amountPaid,
      'barcode': barcode,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      eventId: map['eventId'] ?? '', 
      eventName: map['eventName'] ?? '',
      eventDate: map['eventDate'] ?? '',
      eventTime: map['eventTime'] ?? '',
      eventLocation: map['eventLocation'] ?? '',
      ticketCount: (map['ticketCount'] ?? 0) is int 
          ? map['ticketCount'] ?? 0
          : int.tryParse(map['ticketCount'].toString()) ?? 0,
      amountPaid: (map['amountPaid'] ?? 0) is num 
          ? (map['amountPaid'] ?? 0).toDouble()
          : double.tryParse(map['amountPaid'].toString()) ?? 0.0,
      barcode: map['barcode'] ?? '',
    );
  }
}
