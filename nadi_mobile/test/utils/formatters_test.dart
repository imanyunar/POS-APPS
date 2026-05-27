import 'package:flutter_test/flutter_test.dart';
import 'package:serve_app/core/utils/formatters.dart';

void main() {
  group('ServeFormatters Tests', () {
    test('rupiah formats correctly', () {
      expect(ServeFormatters.rupiah(0), 'Rp 0');
      expect(ServeFormatters.rupiah(4750000), 'Rp 4.750.000');
    });

    test('rupiahCompact formats thousands correctly', () {
      expect(ServeFormatters.rupiahCompact(1200000), 'Rp 1.2 jt');
      expect(ServeFormatters.rupiahCompact(500000), 'Rp 500 rb');
    });
  });
}
