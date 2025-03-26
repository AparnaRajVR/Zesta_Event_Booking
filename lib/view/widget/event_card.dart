import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String location;
  final String ticketPrice;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.location,
    required this.ticketPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imageUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(location, style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(ticketPrice == "Free" ? "🎟 Free Entry" : "💰 $ticketPrice",
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onTap,
                    child: Text("View Details", style: TextStyle(color: Colors.purple)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
