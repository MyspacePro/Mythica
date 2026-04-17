import 'package:flutter/material.dart';

class OfflineVault extends StatelessWidget {
  const OfflineVault({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E), // lighter dark
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.3,
            colors: [
              Color(0xFF2A2250),
              Color(0xFF1E1E2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.download_rounded,
                            color: Colors.white, size: 26),
                        SizedBox(width: 10),
                        Text(
                          "Downloaded Books",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "2.3 GB used",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                /// STORAGE CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha:0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Storage Used",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Downloaded Books Count\n25MB",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// PROGRESS BAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 6,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF9C6CFF)),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Clear All"),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Downloaded Books List",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: ListView(
                    children: const [
                      _DownloadTile(
                        title: "Project Hail Mary",
                        author: "Andy Weir",
                        size: "25MB",
                        downloaded: false,
                      ),
                      SizedBox(height: 15),
                      _DownloadTile(
                        title: "The Midnight Library",
                        author: "Andy Weir",
                        size: "25MB",
                        downloaded: true,
                      ),
                      SizedBox(height: 25),
                      _EmptyStateCard(),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// FLOATING BUTTON
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF9C6CFF),
              Color(0xFF6E4BFF),
            ],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {},
          child: const Icon(Icons.download_for_offline, color: Colors.white),
        ),
      ),
    );
  }
}

/// DOWNLOAD TILE
class _DownloadTile extends StatelessWidget {
  final String title;
  final String author;
  final String size;
  final bool downloaded;

  const _DownloadTile({
    required this.title,
    required this.author,
    required this.size,
    required this.downloaded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: downloaded
              ? const Color(0xFF9C6CFF)
              : Colors.white.withValues(alpha:0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF9C6CFF),
            ),
            child: const Icon(Icons.menu_book, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  author,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  size,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          if (downloaded)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF9C6CFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Downloaded",
                style: TextStyle(
                    color: Colors.white, fontSize: 12),
              ),
            )
          else
            const Icon(Icons.more_vert, color: Colors.white54),
        ],
      ),
    );
  }
}

/// EMPTY STATE CARD
class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Icons.cloud_download,
              size: 60, color: Color(0xFF9C6CFF)),
          SizedBox(height: 15),
          Text(
            "No downloads yet",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Download books to read offline",
            style: TextStyle(
                color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}