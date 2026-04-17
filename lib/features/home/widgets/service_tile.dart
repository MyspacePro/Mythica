class HomeServiceTile extends StatelessWidget {
  final HomeService service;

  const HomeServiceTile({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (service.route.isNotEmpty) {
          Navigator.pushNamed(context, service.route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// OUTER RING
          Container(
            height: size.width * 0.18,
            width: size.width * 0.18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFFD86B),
                width: 2.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD86B).withValues(alpha:0.4),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Container(
                height: size.width * 0.135,
                width: size.width * 0.135,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3C2A5E),
                      Color(0xFF2A2045),
                    ],
                  ),
                ),
                child: Icon(
                  service.icon,
                  size: size.width * 0.1,
                  color: const Color(0xFFFFD86B),
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.012),

          Text(
            service.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE2E2E5),
            ),
          ),
        ],
      ),
    );
  }
}
