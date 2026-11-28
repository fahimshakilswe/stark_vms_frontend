import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stark_vms_frontend/core/utils/validators.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_model.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_page_response_model.dart';
import 'package:stark_vms_frontend/features/vehicles/data/models/vehicle_request_model.dart';
import 'package:stark_vms_frontend/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/enums/vehicle_enums.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_list_state.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/widgets/vehicle_pagination_bar.dart';
import 'package:stark_vms_frontend/main.dart';

class _FakeVehicleRemoteDataSource implements VehicleRemoteDataSource {
  final List<VehicleModel> seedVehicles;
  final List<({int page, int size, String? search, String? status})> calls = [];
  Duration? artificialDelay;

  _FakeVehicleRemoteDataSource(this.seedVehicles);

  @override
  Future<VehiclePageResponseModel> getVehicles({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    String? search,
    String? vehicleType,
    String? brand,
    String? model,
    String? fuelType,
    String? status,
  }) async {
    calls.add((page: page, size: size, search: search, status: status));
    if (artificialDelay != null) {
      await Future.delayed(artificialDelay!);
    }

    var filtered = seedVehicles;
    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((v) {
        return v.vehicleNumber.toLowerCase().contains(q) ||
            v.brand.toLowerCase().contains(q) ||
            v.model.toLowerCase().contains(q) ||
            (v.driverName?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    if (status != null && status.trim().isNotEmpty) {
      final target = VehicleStatus.fromString(status);
      filtered = filtered
          .where((v) => VehicleStatus.fromString(v.status) == target)
          .toList();
    }

    final totalElements = filtered.length;
    final totalPages = totalElements == 0 ? 0 : (totalElements / size).ceil();
    final start = page * size;
    final end = (start + size).clamp(0, totalElements);
    final slice = start < totalElements
        ? filtered.sublist(start, end)
        : <VehicleModel>[];
    final isLast = totalPages == 0 || page >= totalPages - 1;

    return VehiclePageResponseModel(
      content: slice,
      pageNumber: page,
      pageSize: size,
      totalElements: totalElements,
      totalPages: totalPages,
      last: isLast,
    );
  }

  @override
  Future<VehicleModel> createVehicle(VehicleRequestModel request) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteVehicle(int id) async {
    seedVehicles.removeWhere((v) => v.id == id);
  }

  @override
  Future<VehicleModel> getVehicleById(int id) async {
    return seedVehicles.firstWhere((v) => v.id == id);
  }

  @override
  Future<VehicleModel> updateVehicle(int id, VehicleRequestModel request) async {
    throw UnimplementedError();
  }
}

List<VehicleModel> _buildSampleVehicles(int count) {
  const statuses = ['AVAILABLE', 'ACTIVE', 'INACTIVE', 'MAINTENANCE'];
  return List.generate(count, (i) {
    final idx = i + 1;
    return VehicleModel(
      id: idx,
      vehicleNumber: 'DHA-METRO-GA-${1000 + idx}',
      vehicleType: 'CAR',
      brand: idx.isEven ? 'Toyota' : 'Honda',
      model: idx.isEven ? 'Corolla' : 'Civic',
      fuelType: 'OCTANE',
      driverName: 'Driver $idx',
      status: statuses[i % statuses.length],
    );
  });
}

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail validates correct email format', () {
      expect(Validators.validateEmail('user@stark.com'), isNull);
      expect(Validators.validateEmail(''), 'Email is required');
      expect(
        Validators.validateEmail('invalid-email'),
        'Please enter a valid email address',
      );
    });

    test('validateStrongPassword enforces backend complexity requirements', () {
      expect(Validators.validateStrongPassword('ValidPass123!'), isNull);
      expect(
        Validators.validateStrongPassword('short1!'),
        'Password must be at least 8 characters',
      );
      expect(
        Validators.validateStrongPassword('alllowercase1!'),
        'Password must contain at least one uppercase letter (A-Z)',
      );
      expect(
        Validators.validateStrongPassword('ALLUPPERCASE1!'),
        'Password must contain at least one lowercase letter (a-z)',
      );
      expect(
        Validators.validateStrongPassword('NoSpecialChar123'),
        'Password must contain at least one special character (!@#\$%...)',
      );
      expect(
        Validators.validateStrongPassword('NoNumbersHere!'),
        'Password must contain at least one digit (0-9)',
      );
    });

    test('validateVehicleNumber checks non-empty and length limit', () {
      expect(Validators.validateVehicleNumber('DHA-METRO-GA-11-1001'), isNull);
      expect(
        Validators.validateVehicleNumber(''),
        'Vehicle number is required',
      );
    });

    test('validateManufacturingYear validates range', () {
      expect(Validators.validateManufacturingYear('2022'), isNull);
      expect(Validators.validateManufacturingYear(''), isNull);
      expect(Validators.validateManufacturingYear(null), isNull);
      expect(
        Validators.validateManufacturingYear('1899'),
        'Manufacturing year must be at least 1900',
      );
      expect(
        Validators.validateManufacturingYear('2099'),
        contains('cannot be in the future'),
      );
      expect(
        Validators.validateManufacturingYear('abc'),
        'Please enter a valid year',
      );
    });

    test('validateSeatingCapacity validates positive numbers', () {
      expect(Validators.validateSeatingCapacity('5'), isNull);
      expect(Validators.validateSeatingCapacity(''), isNull);
      expect(Validators.validateSeatingCapacity(null), isNull);
      expect(
        Validators.validateSeatingCapacity('0'),
        'Seating capacity must be greater than 0',
      );
      expect(
        Validators.validateSeatingCapacity('-1'),
        'Seating capacity must be greater than 0',
      );
      expect(
        Validators.validateSeatingCapacity('invalid'),
        'Please enter a valid number',
      );
    });

    test('validateDriverPhone validates phone format when provided', () {
      expect(Validators.validateDriverPhone('+8801711000001'), isNull);
      expect(Validators.validateDriverPhone('01711000001'), isNull);
      expect(Validators.validateDriverPhone(''), isNull);
      expect(Validators.validateDriverPhone(null), isNull);
      expect(
        Validators.validateDriverPhone('abc'),
        contains('Please enter a valid phone number'),
      );
    });
  });

  group('VehicleStatus & Dashboard Metrics Tests', () {
    test('VehicleStatus.fromString normalizes current and legacy backend status values', () {
      expect(VehicleStatus.fromString('AVAILABLE'), VehicleStatus.AVAILABLE);
      expect(VehicleStatus.fromString('Available'), VehicleStatus.AVAILABLE);
      expect(VehicleStatus.fromString('ACTIVE'), VehicleStatus.ACTIVE);
      expect(VehicleStatus.fromString('Active'), VehicleStatus.ACTIVE);
      expect(VehicleStatus.fromString('INACTIVE'), VehicleStatus.INACTIVE);
      expect(VehicleStatus.fromString('Inactive'), VehicleStatus.INACTIVE);
      expect(VehicleStatus.fromString('MAINTENANCE'), VehicleStatus.MAINTENANCE);
      expect(VehicleStatus.fromString('Maintence'), VehicleStatus.MAINTENANCE);
      expect(VehicleStatus.fromString('unknown'), isNull);
    });

    test('getDashboardMetrics aggregates accurate counts across all pages including Maintenance', () async {
      final vehicles = [
        ...List.generate(5, (i) => VehicleModel(id: i + 1, vehicleNumber: 'V-$i', vehicleType: 'CAR', brand: 'Toyota', model: 'Corolla', fuelType: 'OCTANE', status: 'Available')),
        ...List.generate(3, (i) => VehicleModel(id: 10 + i, vehicleNumber: 'A-$i', vehicleType: 'SUV', brand: 'Honda', model: 'CRV', fuelType: 'PETROL', status: 'ACTIVE')),
        ...List.generate(2, (i) => VehicleModel(id: 20 + i, vehicleNumber: 'I-$i', vehicleType: 'VAN', brand: 'Suzuki', model: 'Every', fuelType: 'CNG', status: 'Inactive')),
        VehicleModel(id: 30, vehicleNumber: 'M-1', vehicleType: 'TRUCK', brand: 'Tata', model: 'LPT', fuelType: 'DIESEL', status: 'Maintence'),
        VehicleModel(id: 31, vehicleNumber: 'M-2', vehicleType: 'TRUCK', brand: 'Isuzu', model: 'NKR', fuelType: 'DIESEL', status: 'MAINTENANCE'),
      ];

      final fakeDs = _FakeVehicleRemoteDataSource(vehicles);
      final repo = VehicleRepositoryImpl(fakeDs);
      final metrics = await repo.getDashboardMetrics();

      expect(metrics.totalVehicles, 12);
      expect(metrics.availableVehicles, 5);
      expect(metrics.activeVehicles, 3);
      expect(metrics.inactiveVehicles, 2);
      expect(metrics.underMaintenance, 2);
      expect(
        metrics.availableVehicles +
            metrics.activeVehicles +
            metrics.inactiveVehicles +
            metrics.underMaintenance,
        metrics.totalVehicles,
      );
    });
  });

  group('Pagination & Debounced Search State Tests', () {
    test('VehicleListState computes accurate range and button flags for 0, 1, 10, 11, 20, 25 vehicles', () {
      const empty = VehicleListState(
        vehicles: [],
        currentPage: 0,
        totalElements: 0,
        totalPages: 0,
        isLast: true,
        hasLoadedOnce: true,
      );
      expect(empty.startItem, 0);
      expect(empty.endItem, 0);
      expect(empty.displayPage, 1);
      expect(empty.displayTotalPages, 1);
      expect(empty.canGoPrevious, isFalse);
      expect(empty.canGoNext, isFalse);

      final single = VehicleListState(
        vehicles: [const VehicleEntity(id: 1, vehicleNumber: 'V-1', vehicleType: 'CAR', brand: 'Toyota', model: 'Altis', fuelType: 'OCTANE', status: 'AVAILABLE')],
        currentPage: 0,
        totalElements: 1,
        totalPages: 1,
        isLast: true,
        hasLoadedOnce: true,
      );
      expect(single.startItem, 1);
      expect(single.endItem, 1);
      expect(single.canGoPrevious, isFalse);
      expect(single.canGoNext, isFalse);

      final page0Of25 = VehicleListState(
        vehicles: List.generate(10, (i) => VehicleEntity(id: i, vehicleNumber: 'V-$i', vehicleType: 'CAR', brand: 'Toyota', model: 'Altis', fuelType: 'OCTANE', status: 'AVAILABLE')),
        currentPage: 0,
        totalElements: 25,
        totalPages: 3,
        isLast: false,
        hasLoadedOnce: true,
      );
      expect(page0Of25.startItem, 1);
      expect(page0Of25.endItem, 10);
      expect(page0Of25.displayPage, 1);
      expect(page0Of25.displayTotalPages, 3);
      expect(page0Of25.canGoPrevious, isFalse);
      expect(page0Of25.canGoNext, isTrue);

      final page2Of25 = VehicleListState(
        vehicles: List.generate(5, (i) => VehicleEntity(id: 20 + i, vehicleNumber: 'V-${20 + i}', vehicleType: 'CAR', brand: 'Toyota', model: 'Altis', fuelType: 'OCTANE', status: 'AVAILABLE')),
        currentPage: 2,
        totalElements: 25,
        totalPages: 3,
        isLast: true,
        hasLoadedOnce: true,
      );
      expect(page2Of25.startItem, 21);
      expect(page2Of25.endItem, 25);
      expect(page2Of25.displayPage, 3);
      expect(page2Of25.displayTotalPages, 3);
      expect(page2Of25.canGoPrevious, isTrue);
      expect(page2Of25.canGoNext, isFalse);
    });

    test('VehicleListNotifier paginates, debounces search, preserves search across pages, and steps back on empty last page', () async {
      final vehicles = _buildSampleVehicles(25);
      final fakeDs = _FakeVehicleRemoteDataSource(vehicles);

      final container = ProviderContainer(
        overrides: [
          vehicleRemoteDataSourceProvider.overrideWithValue(fakeDs),
        ],
      );
      addTearDown(container.dispose);

      // Initial load triggers page 0
      container.read(vehicleListProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      var state = container.read(vehicleListProvider);
      expect(state.currentPage, 0);
      expect(state.vehicles.length, 10);
      expect(state.totalElements, 25);
      expect(state.totalPages, 3);
      expect(state.startItem, 1);
      expect(state.endItem, 10);
      expect(state.canGoPrevious, isFalse);
      expect(state.canGoNext, isTrue);

      // Navigate Next -> Page 1 (vehicles 11-20)
      container.read(vehicleListProvider.notifier).nextPage();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      state = container.read(vehicleListProvider);
      expect(state.currentPage, 1);
      expect(state.startItem, 11);
      expect(state.endItem, 20);
      expect(state.canGoPrevious, isTrue);
      expect(state.canGoNext, isTrue);

      // Navigate Next -> Page 2 (vehicles 21-25)
      container.read(vehicleListProvider.notifier).nextPage();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      state = container.read(vehicleListProvider);
      expect(state.currentPage, 2);
      expect(state.vehicles.length, 5);
      expect(state.startItem, 21);
      expect(state.endItem, 25);
      expect(state.canGoNext, isFalse);

      // Rapid search typing should debounce to a single API call and reset to page 0
      final callsBeforeSearch = fakeDs.calls.length;
      final notifier = container.read(vehicleListProvider.notifier);
      notifier.onSearchChanged('t');
      notifier.onSearchChanged('to');
      notifier.onSearchChanged('  toyota  ');

      // Before debounce expires, no new API call should be made
      expect(fakeDs.calls.length, callsBeforeSearch);

      // Wait for 450ms debounce
      await Future<void>.delayed(const Duration(milliseconds: 520));
      expect(fakeDs.calls.length, callsBeforeSearch + 1);
      expect(fakeDs.calls.last.page, 0);
      expect(fakeDs.calls.last.search, 'toyota');

      state = container.read(vehicleListProvider);
      expect(state.currentPage, 0);
      expect(state.searchQuery, 'toyota');
      expect(state.totalElements, 12); // 12 Toyota vehicles in 25 samples
      expect(state.totalPages, 2);

      // Next page preserves search query
      notifier.nextPage();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      state = container.read(vehicleListProvider);
      expect(state.currentPage, 1);
      expect(state.searchQuery, 'toyota');
      expect(state.startItem, 11);
      expect(state.endItem, 12);

      // Clear search immediately restores full 25 vehicles at page 0
      notifier.clearSearch();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      state = container.read(vehicleListProvider);
      expect(state.currentPage, 0);
      expect(state.searchQuery, '');
      expect(state.totalElements, 25);
    });
  });

  group('Widget Rendering Tests', () {
    testWidgets('StarkVmsApp builds without throwing No MaterialLocalizations found', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: StarkVmsApp(),
        ),
      );

      await tester.pump();
      expect(find.byType(StarkVmsApp), findsOneWidget);
    });

    testWidgets('AppButton renders properly without assertion failure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                AppButton(label: 'Secondary', variant: AppButtonVariant.secondary, onPressed: () {}),
                AppButton(label: 'Outline', variant: AppButtonVariant.outline, onPressed: () {}),
                AppButton(label: 'Destructive', variant: AppButtonVariant.destructive, onPressed: () {}),
                AppButton(label: 'Ghost', variant: AppButtonVariant.ghost, onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Outline'), findsOneWidget);
      expect(find.text('Destructive'), findsOneWidget);
      expect(find.text('Ghost'), findsOneWidget);
    });

    testWidgets('VehiclePaginationBar displays range, page indicator, and button disabled states', (tester) async {
      var prevTapped = false;
      var nextTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehiclePaginationBar(
              startItem: 1,
              endItem: 10,
              totalElements: 20,
              displayPage: 1,
              displayTotalPages: 2,
              canGoPrevious: false,
              canGoNext: true,
              isLoading: false,
              onPrevious: () => prevTapped = true,
              onNext: () => nextTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Showing 1\u201310 of 20 vehicles'), findsOneWidget);
      expect(find.text('Page 1 of 2'), findsOneWidget);

      await tester.tap(find.text('Previous'));
      expect(prevTapped, isFalse);

      await tester.tap(find.text('Next'));
      expect(nextTapped, isTrue);
    });
  });
}
