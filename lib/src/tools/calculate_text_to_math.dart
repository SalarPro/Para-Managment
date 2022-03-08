/*
Parser buildParser() {
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive((pattern('+-').optional() &
            digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map(num.tryParse))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()
    ..prefix(
        char('-').trim(), (op, a) => -((a is int ? a as int : a as double)));
  builder.group()
    ..right(
        char('^').trim(),
        (a, op, b) => pow((a is int ? a as int : a as double),
            (b is int ? a as int : a as double)));
  builder.group()
    ..left(
        char('X').trim(),
        (a, op, b) =>
            (a is int ? a as int : a as double) *
            (b is int ? a as int : a as double))
    ..left(
        char('/').trim(),
        (a, op, b) =>
            (a is int ? a as int : a as double) /
            (b is int ? a as int : a as double));
  builder.group()
    ..left(
        char('+').trim(),
        (a, op, b) =>
            (a is int ? a as int : a as double) +
            (b is int ? a as int : a as double))
    ..left(
        char('-').trim(),
        (a, op, b) =>
            (a is int ? a as int : a as double) -
            (b is int ? a as int : a as double));
  return builder.build().end();
}
*/
import 'package:function_tree/function_tree.dart';

String calcString(String text) {
  try {
    return text.interpret().toString();
  } catch (e) {
    return e.toString();
  }

  // try {
  //   Parser p = Parser();
  //   Expression exp = p.parse(text);
  //   return exp.toString();
  // } catch (e) {
  //   return e.toString();
  // }
  // final parser = buildParser();
  // final input = text;
  // final result = parser.parse(input);
  // if (result.isSuccess)
  //   return result.value.toString();
  // else
  //   return (text);
}
