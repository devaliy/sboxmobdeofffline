import 'dart:math';

import 'mock_pack_builder.dart';
import 'mock_user.dart';

/// The mock backend's entire state, in one place, living for the app's
/// process lifetime (a Riverpod-held singleton — see [mockBackendStoreProvider]).
/// Resetting on hot-restart is fine: it's a development stand-in, and the
/// app's own graceful token-expiry handling (spec Section 8) means a
/// "server forgot me" reset behaves exactly like a real expired token,
/// which is worth exercising anyway.
class MockBackendStore {
  MockBackendStore() {
    _seedUsers();
    _seedContent();
  }

  // --- Users & auth --------------------------------------------------------

  final List<MockUser> users = [];
  final Map<String, int> _tokenToUserId = {};
  final Map<String, String> _pendingOtps = {}; // phone/email -> otp
  int _nextUserId = 100;
  final Random _random = Random();

  void _seedUsers() {
    users.addAll([
      MockUser(
        id: 1,
        firstName: 'Jane',
        lastName: 'Davies',
        email: 'jane@demo.ng',
        phoneNumber: '+2348012340001',
        password: 'password123',
        currentClassId: 8, // JSS 2
      ),
      MockUser(
        id: 2,
        firstName: 'Musa',
        lastName: 'Bello',
        email: 'musa@demo.ng',
        phoneNumber: '+2348012340002',
        password: 'password123',
        currentClassId: 10, // SS 1
      ),
    ]);
  }

  MockUser? findByLoginIdentifier(String identifier) {
    for (final u in users) {
      if (u.matchesLogin(identifier)) return u;
    }
    return null;
  }

  MockUser? findById(int id) {
    for (final u in users) {
      if (u.id == id) return u;
    }
    return null;
  }

  bool identifierTaken(String email, String phone) =>
      users.any((u) => u.email == email || u.phoneNumber == phone);

  MockUser createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required int currentClassId,
  }) {
    final user = MockUser(
      id: _nextUserId++,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      currentClassId: currentClassId,
    );
    users.add(user);
    return user;
  }

  String issueToken(int userId) {
    final token = 'mock-token-$userId-${_random.nextInt(1000000)}';
    _tokenToUserId[token] = userId;
    return token;
  }

  MockUser? userForToken(String? bearerHeader) {
    if (bearerHeader == null || !bearerHeader.startsWith('Bearer ')) return null;
    final token = bearerHeader.substring('Bearer '.length);
    final userId = _tokenToUserId[token];
    if (userId == null) return null;
    return findById(userId);
  }

  void revokeToken(String? bearerHeader) {
    if (bearerHeader == null || !bearerHeader.startsWith('Bearer ')) return;
    _tokenToUserId.remove(bearerHeader.substring('Bearer '.length));
  }

  String issueOtp(String identifier) {
    final otp = (1000 + _random.nextInt(9000)).toString();
    _pendingOtps[identifier] = otp;
    return otp; // "sent" — the mock just returns it so the UI can display it, no real SMS/email.
  }

  bool verifyAndConsumeOtp(String identifier, String otp) {
    if (_pendingOtps[identifier] == otp) {
      _pendingOtps.remove(identifier);
      return true;
    }
    return false;
  }

  // --- Sync receipts (inspected by M8's tests) ------------------------------

  final List<Map<String, dynamic>> receivedPracticeAttempts = [];
  final List<Map<String, dynamic>> receivedReadingProgress = [];

  // --- Content: manifest + packs --------------------------------------------

  late final BuiltPack studyPack;
  late final BuiltPack assessmentPack;

  static const studyBookScopeId = 12;
  static const studyClassScopeId = 8; // JSS 2, matches kClassOptions
  static const assessmentSubjectScopeId = 7;

  void _seedContent() {
    studyPack = MockPackBuilder.buildStudyPack(
      scopeId: studyBookScopeId,
      version: '20260720-1000',
      classJson: const {
        'id': studyClassScopeId,
        'name': 'JSS 2',
        'code': 'JSS2',
        'sort_order': 8,
        'category': 'juniorsecondary',
      },
      bookJson: const {
        'id': studyBookScopeId,
        'class_id': studyClassScopeId,
        'name': 'Mathematics',
        'image': null,
        'color': '#3B82F6',
      },
      termsJson: const [
        {'id': 1, 'name': 'First Term', 'start_date': '2026-09-01', 'end_date': '2026-12-10'},
      ],
      subjectsJson: const [
        {
          'id': 101,
          'library_book_id': studyBookScopeId,
          'term_id': 1,
          'title': 'Week 1: Algebra Basics',
          'description': 'Introduction to algebraic expressions',
          'cover_image': null,
          'author': 'Chronicles Revolution',
          'week': 1,
          'num_of_test_questions': 2,
          'contents': [
            {
              'id': 501,
              'content':
                  '<h3>Acids &amp; Bases</h3><p>Algebraic expressions combine numbers, letters, and operators.</p>'
                      '<p>For example, <strong>2x + 3</strong> is an expression where <em>x</em> is a variable.</p>',
            },
          ],
          'questions': [
            {
              'id': 9001,
              'question_text': 'What is x in 2x = 4?',
              'image': null,
              'option_a': '1',
              'option_b': '2',
              'option_c': '3',
              'option_d': '4',
              'option_e': null,
              'correct_option': 'B',
              'explanation': 'Divide both sides by 2: x = 4 / 2 = 2.',
            },
            {
              'id': 9002,
              'question_text': 'Simplify: 3x + 2x',
              'image': null,
              'option_a': '5x',
              'option_b': '6x',
              'option_c': '5x^2',
              'option_d': 'x',
              'option_e': null,
              'correct_option': 'A',
              'explanation': 'Like terms add directly: 3x + 2x = 5x.',
            },
          ],
        },
      ],
    );

    assessmentPack = MockPackBuilder.buildAssessmentPack(
      scopeId: assessmentSubjectScopeId,
      version: '20260718-0930',
      subjectJson: const {'id': assessmentSubjectScopeId, 'name': 'Physics'},
      categoriesJson: const [
        {'id': 2, 'cat_name': 'Objective'},
      ],
      yearsJson: const [
        {'id': 55, 'subject_id': assessmentSubjectScopeId, 'year_name': '2019'},
      ],
      testTypesJson: const [
        {
          'id': 3,
          'test_type_name': 'JAMB Practice',
          'duration_minutes': 40,
          'num_of_questions': 4,
          'subject_id': assessmentSubjectScopeId,
          'assoc_category_id': 2,
        },
      ],
      passagesJson: const [
        {
          'id': 60001,
          'title': 'Newton\'s Laws of Motion',
          'year_id': 55,
          'passage_text':
              'Sir Isaac Newton formulated three laws describing the relationship between a body '
                  'and the forces acting upon it. The first law states that a body remains at rest, '
                  'or in motion at a constant velocity, unless acted upon by an external force. The '
                  'second law relates force, mass and acceleration as F = ma. The third law states '
                  'that for every action there is an equal and opposite reaction.',
        },
      ],
      questionsJson: const [
        {
          'id': 30021,
          'subject_id': assessmentSubjectScopeId,
          'category_id': 2,
          'year_id': 55,
          'passage_id': null,
          'test_type_id': 3,
          'question_text': 'What is the acceleration due to gravity (approx.)?',
          'image': null,
          'option_a': '9.8 m/s²',
          'option_b': '10.8 m/s²',
          'option_c': '8.8 m/s²',
          'option_d': '11.8 m/s²',
          'option_e': null,
          'correct_option': 'A',
          'explanation': 'Standard gravity is approximately 9.8 m/s² near Earth\'s surface.',
        },
        {
          'id': 30022,
          'subject_id': assessmentSubjectScopeId,
          'category_id': 2,
          'year_id': 55,
          'passage_id': null,
          'test_type_id': 3,
          'question_text': 'The SI unit of force is:',
          'image': null,
          'option_a': 'Joule',
          'option_b': 'Newton',
          'option_c': 'Watt',
          'option_d': 'Pascal',
          'option_e': null,
          'correct_option': 'B',
          'explanation': 'Force is measured in Newtons (N), per Newton\'s second law.',
        },
        {
          'id': 30023,
          'subject_id': assessmentSubjectScopeId,
          'category_id': 2,
          'year_id': 55,
          'passage_id': 60001,
          'test_type_id': 3,
          'question_text': 'According to the passage, a body in motion stays in motion unless:',
          'image': null,
          'option_a': 'It runs out of energy',
          'option_b': 'An external force acts on it',
          'option_c': 'Its mass changes',
          'option_d': 'It reaches maximum velocity',
          'option_e': null,
          'correct_option': 'B',
          'explanation': 'This is Newton\'s first law (the law of inertia), stated directly in the passage.',
        },
        {
          'id': 30024,
          'subject_id': assessmentSubjectScopeId,
          'category_id': 2,
          'year_id': 55,
          'passage_id': 60001,
          'test_type_id': 3,
          'question_text': 'Per the passage, Newton\'s second law is expressed as:',
          'image': null,
          'option_a': 'F = ma',
          'option_b': 'E = mc²',
          'option_c': 'V = IR',
          'option_d': 'P = mv',
          'option_e': null,
          'correct_option': 'A',
          'explanation': 'The passage states the second law relates force, mass and acceleration as F = ma.',
        },
      ],
    );
  }

  Map<String, dynamic> manifestJson() => {
        'generated_at': DateTime.now().toUtc().toIso8601String(),
        'packs': [
          {
            'domain': 'study',
            'scope_type': 'book',
            'scope_id': studyBookScopeId,
            'parent_scope_id': studyClassScopeId,
            'title': 'JSS2 Mathematics',
            'version': studyPack.version,
            'checksum': studyPack.checksum,
            'size_bytes': studyPack.sizeBytes,
            'item_count': studyPack.itemCount,
            'download_url': '/api/v1/content/study/$studyBookScopeId/pack',
          },
          {
            'domain': 'assessment',
            'scope_type': 'subject',
            'scope_id': assessmentSubjectScopeId,
            'parent_scope_id': null,
            'title': 'Physics',
            'version': assessmentPack.version,
            'checksum': assessmentPack.checksum,
            'size_bytes': assessmentPack.sizeBytes,
            'item_count': assessmentPack.itemCount,
            'download_url': '/api/v1/content/assessment/$assessmentSubjectScopeId/pack',
          },
        ],
      };
}
