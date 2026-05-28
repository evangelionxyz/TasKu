import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OrganizerItem {
  const OrganizerItem({
    required this.id,
    required this.name,
    required this.isPacked,
    required this.createdAt,
    this.category,
  });

  final String id;
  final String name;
  final bool isPacked;
  final DateTime createdAt;
  final String? category;

  factory OrganizerItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrganizerItem(
      id: doc.id,
      name: data['name'] as String? ?? '',
      isPacked: data['isPacked'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] as String?,
    );
  }
}

class OrganizerService extends ChangeNotifier {
  OrganizerService() {
    // Subscribe to auth state — re-start Firestore listener when uid changes.
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      _uid = user?.uid;
      _subscription?.cancel();
      _subscription = null;
      _items = [];
      if (_uid != null) {
        _startListening();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  String? _uid;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot>? _subscription;

  List<OrganizerItem> _items = [];
  bool _isLoading = false;

  List<OrganizerItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  CollectionReference<Map<String, dynamic>>? get _collection {
    final uid = _uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items');
  }

  void _startListening() {
    final col = _collection;
    if (col == null) return;

    _isLoading = true;
    notifyListeners();

    _subscription = col
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snap) {
          _items = snap.docs.map(OrganizerItem.fromDoc).toList();
          _isLoading = false;
          notifyListeners();
        }, onError: (_) {
          _isLoading = false;
          notifyListeners();
        });
  }

  Future<void> addItem(String name) async {
    await _collection?.add({
      'name': name.trim(),
      'isPacked': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> togglePacked(String itemId, bool currentState) async {
    await _collection?.doc(itemId).update({'isPacked': !currentState});
  }

  Future<void> deleteItem(String itemId) async {
    await _collection?.doc(itemId).delete();
  }

  Future<void> updateItem(String itemId, String newName) async {
    await _collection?.doc(itemId).update({'name': newName.trim()});
  }

  /// Force re-fetch by restarting the Firestore listener.
  Future<void> refresh() async {
    await _subscription?.cancel();
    _subscription = null;
    _startListening();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
