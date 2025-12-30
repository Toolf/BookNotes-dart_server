enum FilterCondition {
  equal,
  notEqual,
  startWith,
  endsWith,
  contains,
  containsWord,
  like,
  regexp,
  greater,
  greaterOrEqual,
  less,
  lessOrEqual,
  between,
  notSet,
  notExists,
  hasValue
}


class SqlFragment {
  final String sql;
  final List<dynamic> params;

  SqlFragment(this.sql, [List<dynamic>? params])
      : params = params ?? [];

  SqlFragment operator +(SqlFragment other) =>
      SqlFragment(
        '$sql ${other.sql}',
        [...params, ...other.params],
      );
}

abstract class Attribute {
  final String entity;
  Attribute(this.entity);

  SqlFragment apply();
}

class Column extends Attribute {
  final String name;

  Column(super.entity, this.name);

  @override
  SqlFragment apply() => SqlFragment('$entity.$name');
}

class Value extends Attribute {
  final dynamic value;

  Value(this.value) : super('');

  @override
  SqlFragment apply() => SqlFragment('?', [value]);
}

enum ExpressionOperator { and, or, not }

class Expression extends Attribute {
  final ExpressionOperator operator;
  final List<Attribute> attributes;

  Expression(super.entity, this.operator, this.attributes);

  @override
  SqlFragment apply() {
    final parts = attributes.map((a) => a.apply()).toList();

    if (operator == ExpressionOperator.not) {
      final merged = parts.reduce(_mergeAnd);
      return SqlFragment('NOT (${merged.sql})', merged.params);
    }

    final glue = operator == ExpressionOperator.and ? 'AND' : 'OR';

    final sql = parts.map((p) => '(${p.sql})').join(' $glue ');
    final params = parts.expand((p) => p.params).toList();

    return SqlFragment(sql, params);
  }

  SqlFragment _mergeAnd(SqlFragment a, SqlFragment b) =>
      SqlFragment('${a.sql} AND ${b.sql}', [...a.params, ...b.params]);
}

class Filter extends Attribute {
  final FilterCondition condition;
  final Attribute left;
  final Attribute right;

  Filter(
    super.entity,
    this.condition,
    this.left,
    this.right,
  );

  @override
  SqlFragment apply() {
    final l = left.apply();
    final r = right.apply();

    switch (condition) {
      case FilterCondition.equal:
        return _binary(l, '=', r);

      case FilterCondition.notEqual:
        return _binary(l, '!=', r);

      case FilterCondition.greater:
        return _binary(l, '>', r);

      case FilterCondition.greaterOrEqual:
        return _binary(l, '>=', r);

      case FilterCondition.less:
        return _binary(l, '<', r);

      case FilterCondition.lessOrEqual:
        return _binary(l, '<=', r);

      case FilterCondition.startWith:
        return _like(l, r, suffix: '%');

      case FilterCondition.endsWith:
        return _like(l, r, prefix: '%');

      case FilterCondition.contains:
        return _like(l, r, prefix: '%', suffix: '%');

      case FilterCondition.like:
        return _ilike(l, r, prefix: '%', suffix: '%');

      case FilterCondition.containsWord:
        return _regex(l, r, wordBoundary: true);

      case FilterCondition.regexp:
        return _regex(l, r);

      case FilterCondition.hasValue:
        return SqlFragment('${l.sql} IS NOT NULL');

      case FilterCondition.notSet:
        return SqlFragment('${l.sql} IS NULL');

      default:
        throw UnimplementedError('Condition $condition');
    }
  }

  SqlFragment _binary(SqlFragment l, String op, SqlFragment r) =>
      SqlFragment('${l.sql} $op ${r.sql}', [...l.params, ...r.params]);

  SqlFragment _like(
    SqlFragment l,
    SqlFragment r, {
    String prefix = '',
    String suffix = '',
  }) {
    return SqlFragment(
      '${l.sql} LIKE ?',
      [...l.params, '$prefix${r.params.first}$suffix'],
    );
  }

  SqlFragment _ilike(
    SqlFragment l,
    SqlFragment r, {
    String prefix = '',
    String suffix = '',
  }) {
    return SqlFragment(
      '${l.sql} ILIKE ?',
      [...l.params, '$prefix${r.params.first}$suffix'],
    );
  }

  SqlFragment _regex(
    SqlFragment l,
    SqlFragment r, {
    bool wordBoundary = false,
  }) {
    final pattern = wordBoundary
        ? r'\\m' + r.params.first + r'\\M'
        : r.params.first;

    return SqlFragment(
      '${l.sql} ~* ?',
      [...l.params, pattern],
    );
  }
}

class Exists extends Attribute {
  final String table;
  final String condition;

  Exists(super.entity, this.table, this.condition);

  @override
  SqlFragment apply() =>
      SqlFragment('EXISTS (SELECT 1 FROM $table WHERE $condition)');
}


class RelationFilter extends Attribute {
  final String table;
  final String join;
  final Attribute where;

  RelationFilter(
    super.entity, {
    required this.table,
    required this.join,
    required this.where,
  });

  @override
  SqlFragment apply() {
    final w = where.apply();

    return SqlFragment(
      'EXISTS (SELECT 1 FROM $table WHERE $join AND ${w.sql})',
      w.params,
    );
  }
}
