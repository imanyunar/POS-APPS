import 'package:intl/intl.dart';

class ServeFormatters {
  ServeFormatters._();

  static String rupiah(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String rupiahCompact(num amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)} M';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)} rb';
    }
    return rupiah(amount);
  }

  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';

    return DateFormat('d MMM yyyy', 'id_ID').format(dateTime);
  }

  static String dateIndonesian(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  static String dateShort(DateTime date) {
    return DateFormat('d MMM', 'id_ID').format(date);
  }

  static String dateTimeIndonesian(DateTime dt) {
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dt);
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  static String normalizePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.startsWith('0')) {
      return '+62${cleaned.substring(1)}';
    }
    if (cleaned.startsWith('62')) {
      return '+$cleaned';
    }
    return '+62$cleaned';
  }

  static String whatsAppLink(String phone, {String? message}) {
    final normalized = normalizePhone(phone).replaceAll('+', '');
    final encoded = message != null ? Uri.encodeComponent(message) : '';
    return 'https://wa.me/$normalized${encoded.isNotEmpty ? "?text=$encoded" : ""}';
  }

  static String generateInvoiceNumber(int sequence) {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final seq = sequence.toString().padLeft(3, '0');
    return 'INV-$date-$seq';
  }

  static String generateOrderNumber(int sequence) {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final seq = sequence.toString().padLeft(3, '0');
    return 'ORD-$date-$seq';
  }
}
