// Mocks generated by Mockito 5.4.4 from annotations
// in wallet/test/mocks/frb.objects.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:wallet/rust/api/bdk_wallet/address.dart' as _i5;
import 'package:wallet/rust/api/bdk_wallet/amount.dart' as _i3;
import 'package:wallet/rust/api/bdk_wallet/balance.dart' as _i2;
import 'package:wallet/rust/api/bdk_wallet/derivation_path.dart' as _i4;
import 'package:wallet/rust/api/bdk_wallet/transaction_details.dart' as _i8;
import 'package:wallet/rust/api/bdk_wallet/transaction_details_txop.dart'
    as _i9;
import 'package:wallet/rust/common/keychain_kind.dart' as _i7;
import 'package:wallet/rust/common/transaction_time.dart' as _i10;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFrbBalance_0 extends _i1.SmartFake implements _i2.FrbBalance {
  _FakeFrbBalance_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFrbAmount_1 extends _i1.SmartFake implements _i3.FrbAmount {
  _FakeFrbAmount_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFrbDerivationPath_2 extends _i1.SmartFake
    implements _i4.FrbDerivationPath {
  _FakeFrbDerivationPath_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FrbAddressDetails].
///
/// See the documentation for Mockito's code generation for more information.
class MockFrbAddressDetails extends _i1.Mock implements _i5.FrbAddressDetails {
  MockFrbAddressDetails() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get address => (super.noSuchMethod(
        Invocation.getter(#address),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#address),
        ),
      ) as String);

  @override
  _i2.FrbBalance get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: _FakeFrbBalance_0(
          this,
          Invocation.getter(#balance),
        ),
      ) as _i2.FrbBalance);

  @override
  int get index => (super.noSuchMethod(
        Invocation.getter(#index),
        returnValue: 0,
      ) as int);

  @override
  bool get isTransEmpty => (super.noSuchMethod(
        Invocation.getter(#isTransEmpty),
        returnValue: false,
      ) as bool);

  @override
  _i7.KeychainKind get keychain => (super.noSuchMethod(
        Invocation.getter(#keychain),
        returnValue: _i7.KeychainKind.external_,
      ) as _i7.KeychainKind);

  @override
  List<_i8.FrbTransactionDetails> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue: <_i8.FrbTransactionDetails>[],
      ) as List<_i8.FrbTransactionDetails>);

  @override
  bool get isDisposed => (super.noSuchMethod(
        Invocation.getter(#isDisposed),
        returnValue: false,
      ) as bool);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [FrbAmount].
///
/// See the documentation for Mockito's code generation for more information.
class MockFrbAmount extends _i1.Mock implements _i3.FrbAmount {
  MockFrbAmount() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isDisposed => (super.noSuchMethod(
        Invocation.getter(#isDisposed),
        returnValue: false,
      ) as bool);

  @override
  double toBtc() => (super.noSuchMethod(
        Invocation.method(
          #toBtc,
          [],
        ),
        returnValue: 0.0,
      ) as double);

  @override
  BigInt toSat() => (super.noSuchMethod(
        Invocation.method(
          #toSat,
          [],
        ),
        returnValue: _i6.dummyValue<BigInt>(
          this,
          Invocation.method(
            #toSat,
            [],
          ),
        ),
      ) as BigInt);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [FrbBalance].
///
/// See the documentation for Mockito's code generation for more information.
class MockFrbBalance extends _i1.Mock implements _i2.FrbBalance {
  MockFrbBalance() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isDisposed => (super.noSuchMethod(
        Invocation.getter(#isDisposed),
        returnValue: false,
      ) as bool);

  @override
  _i3.FrbAmount total() => (super.noSuchMethod(
        Invocation.method(
          #total,
          [],
        ),
        returnValue: _FakeFrbAmount_1(
          this,
          Invocation.method(
            #total,
            [],
          ),
        ),
      ) as _i3.FrbAmount);

  @override
  _i3.FrbAmount trustedSpendable() => (super.noSuchMethod(
        Invocation.method(
          #trustedSpendable,
          [],
        ),
        returnValue: _FakeFrbAmount_1(
          this,
          Invocation.method(
            #trustedSpendable,
            [],
          ),
        ),
      ) as _i3.FrbAmount);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [FrbTransactionDetails].
///
/// See the documentation for Mockito's code generation for more information.
class MockFrbTransactionDetails extends _i1.Mock
    implements _i8.FrbTransactionDetails {
  MockFrbTransactionDetails() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FrbDerivationPath get accountDerivationPath => (super.noSuchMethod(
        Invocation.getter(#accountDerivationPath),
        returnValue: _FakeFrbDerivationPath_2(
          this,
          Invocation.getter(#accountDerivationPath),
        ),
      ) as _i4.FrbDerivationPath);

  @override
  BigInt get value => (super.noSuchMethod(
        Invocation.getter(#value),
        returnValue: _i6.dummyValue<BigInt>(
          this,
          Invocation.getter(#value),
        ),
      ) as BigInt);

  @override
  BigInt get valueWithFee => (super.noSuchMethod(
        Invocation.getter(#valueWithFee),
        returnValue: _i6.dummyValue<BigInt>(
          this,
          Invocation.getter(#valueWithFee),
        ),
      ) as BigInt);

  @override
  bool get isSend => (super.noSuchMethod(
        Invocation.getter(#isSend),
        returnValue: false,
      ) as bool);

  @override
  List<_i9.FrbDetailledTxOutput> get outputs => (super.noSuchMethod(
        Invocation.getter(#outputs),
        returnValue: <_i9.FrbDetailledTxOutput>[],
      ) as List<_i9.FrbDetailledTxOutput>);

  @override
  _i10.TransactionTime get time => (super.noSuchMethod(
        Invocation.getter(#time),
        returnValue: _i6.dummyValue<_i10.TransactionTime>(
          this,
          Invocation.getter(#time),
        ),
      ) as _i10.TransactionTime);

  @override
  String get txid => (super.noSuchMethod(
        Invocation.getter(#txid),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#txid),
        ),
      ) as String);

  @override
  BigInt get vbytesSize => (super.noSuchMethod(
        Invocation.getter(#vbytesSize),
        returnValue: _i6.dummyValue<BigInt>(
          this,
          Invocation.getter(#vbytesSize),
        ),
      ) as BigInt);

  @override
  bool get isDisposed => (super.noSuchMethod(
        Invocation.getter(#isDisposed),
        returnValue: false,
      ) as bool);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
