import 'package:book_notes/core/filter/logic_filter.dart';
import 'package:test/test.dart';

String normalize(String sql) =>
    sql.replaceAll(RegExp(r'\s+'), ' ').trim();


void main() {
  test('users with TestAccount permission via user_group', () {
    final filter = RelationFilter(
      'users',
      table: 'user_group',
      join: 'user_group.user_id = users.id',
      where: Filter(
        'group_permission',
        FilterCondition.equal,
        Column('group_permission', 'permission'),
        Value('TestAccount'),
      ),
    );

    final result = filter.apply();

    expect(
      result.sql.replaceAll(RegExp(r'\s+'), ' ').trim(),
      equals(
        'EXISTS (SELECT 1 FROM user_group WHERE user_group.user_id = users.id '
        'AND group_permission.permission = ?)',
      ),
    );

    expect(result.params, equals(['TestAccount']));
  });

  group('Basic comparison filters', () {
  test('equal', () {
    final f = Filter(
      'users',
      FilterCondition.equal,
      Column('users', 'id'),
      Value(1),
    );

    final r = f.apply();
    expect(r.sql, 'users.id = ?');
    expect(r.params, [1]);
  });

  test('not equal', () {
    final r = Filter(
      'users',
      FilterCondition.notEqual,
      Column('users', 'status'),
      Value('inactive'),
    ).apply();

    expect(r.sql, 'users.status != ?');
    expect(r.params, ['inactive']);
  });

  test('greater / less', () {
    final r = Filter(
      'users',
      FilterCondition.greater,
      Column('users', 'age'),
      Value(18),
    ).apply();

    expect(r.sql, 'users.age > ?');
    expect(r.params, [18]);
  });
});

group('LIKE filters', () {
  test('startsWith (^=)', () {
    final r = Filter(
      'users',
      FilterCondition.startWith,
      Column('users', 'name'),
      Value('Jo'),
    ).apply();

    expect(r.sql, 'users.name LIKE ?');
    expect(r.params, ['Jo%']);
  });

  test('endsWith (\$=)', () {
    final r = Filter(
      'users',
      FilterCondition.endsWith,
      Column('users', 'email'),
      Value('@gmail.com'),
    ).apply();

    expect(r.params, ['%@gmail.com']);
  });

  test('contains (*=)', () {
    final r = Filter(
      'users',
      FilterCondition.contains,
      Column('users', 'bio'),
      Value('dart'),
    ).apply();

    expect(r.params, ['%dart%']);
  });

  test('case-insensitive like (~~*)', () {
    final r = Filter(
      'users',
      FilterCondition.like,
      Column('users', 'username'),
      Value('admin'),
    ).apply();

    expect(r.sql, 'users.username ILIKE ?');
    expect(r.params, ['%admin%']);
  });
});
group('Regex filters', () {
  test('regexp (~)', () {
    final r = Filter(
      'users',
      FilterCondition.regexp,
      Column('users', 'phone'),
      Value(r'^\+1'),
    ).apply();

    expect(r.sql, 'users.phone ~* ?');
    expect(r.params, [r'^\+1']);
  });

  test('containsWord (~=)', () {
    final r = Filter(
      'users',
      FilterCondition.containsWord,
      Column('users', 'description'),
      Value('admin'),
    ).apply();

    expect(r.params.first, contains(r'\m'));
    expect(r.params.first, contains(r'\M'));
  });
});
group('NULL filters', () {
  test('hasValue', () {
    final r = Filter(
      'users',
      FilterCondition.hasValue,
      Column('users', 'deleted_at'),
      Value(null),
    ).apply();

    expect(r.sql, 'users.deleted_at IS NOT NULL');
  });

  test('notSet', () {
    final r = Filter(
      'users',
      FilterCondition.notSet,
      Column('users', 'deleted_at'),
      Value(null),
    ).apply();

    expect(r.sql, 'users.deleted_at IS NULL');
  });
});
group('Logical expressions', () {
  test('AND expression', () {
    final r = Expression(
      'users',
      ExpressionOperator.and,
      [
        Filter(
          'users',
          FilterCondition.equal,
          Column('users', 'active'),
          Value(true),
        ),
        Filter(
          'users',
          FilterCondition.greater,
          Column('users', 'age'),
          Value(18),
        ),
      ],
    ).apply();

    expect(
      normalize(r.sql),
      '(users.active = ?) AND (users.age > ?)',
    );
    expect(r.params, [true, 18]);
  });

  test('OR expression', () {
    final r = Expression(
      'users',
      ExpressionOperator.or,
      [
        Filter(
          'users',
          FilterCondition.equal,
          Column('users', 'role'),
          Value('admin'),
        ),
        Filter(
          'users',
          FilterCondition.equal,
          Column('users', 'role'),
          Value('manager'),
        ),
      ],
    ).apply();

    expect(r.params, ['admin', 'manager']);
  });
});
group('NOT expressions', () {
  test('NOT single filter', () {
    final r = Expression(
      'users',
      ExpressionOperator.not,
      [
        Filter(
          'users',
          FilterCondition.equal,
          Column('users', 'blocked'),
          Value(true),
        ),
      ],
    ).apply();

    expect(normalize(r.sql), 'NOT (users.blocked = ?)');
    expect(r.params, [true]);
  });
});
group('Relation filters', () {
  test('users with TestAccount permission', () {
    final permissionFilter = RelationFilter(
      'user_group',
      table: 'group_permissions',
      join: 'group_permission.group_id = user_group.id',
      where: Filter(
        'group_permission',
        FilterCondition.equal,
        Column('group_permission', 'permission'),
        Value('TestAccount'),
      ),
    );

    final userFilter = RelationFilter(
      'users',
      table: 'user_group',
      join: 'user_group.user_id = users.id',
      where: permissionFilter.where,
    );

    final r = userFilter.apply();

    expect(normalize(r.sql), contains('EXISTS'));
    expect(r.params, ['TestAccount']);
  });
});
test('complex nested filter', () {
  final r = Expression(
    'users',
    ExpressionOperator.and,
    [
      Filter(
        'users',
        FilterCondition.like,
        Column('users', 'email'),
        Value('@company.com'),
      ),
      Expression(
        'users',
        ExpressionOperator.not,
        [
          Filter(
            'users',
            FilterCondition.equal,
            Column('users', 'blocked'),
            Value(true),
          ),
        ],
      ),
    ],
  ).apply();

  expect(r.params, ['%@company.com%', true]);
});

}
