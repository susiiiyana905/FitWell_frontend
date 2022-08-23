// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      thisMonthView: json['thisMonthView'] as bool?,
      expenseDays: (json['expenseDays'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      expenseAmounts: (json['expenseAmounts'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      maxExpenseAmount: json['maxExpenseAmount'] as int?,
      thisMonthExpenseCategories: (json['thisMonthExpenseCategories']
              as List<dynamic>?)
          ?.map((e) => ExpenseCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthIncomeCategories: (json['thisMonthIncomeCategories']
              as List<dynamic>?)
          ?.map((e) => IncomeCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthExpenseAmount: json['thisMonthExpenseAmount'] as int?,
      thisMonthIncomeAmount: json['thisMonthIncomeAmount'] as int?,
      previousMonthExpenseAmount: json['previousMonthExpenseAmount'] as int?,
      previousMonthIncomeAmount: json['previousMonthIncomeAmount'] as int?,
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'thisMonthView': instance.thisMonthView,
      'expenseDays': instance.expenseDays,
      'expenseAmounts': instance.expenseAmounts,
      'maxExpenseAmount': instance.maxExpenseAmount,
      'thisMonthExpenseCategories': instance.thisMonthExpenseCategories,
      'thisMonthIncomeCategories': instance.thisMonthIncomeCategories,
      'thisMonthExpenseAmount': instance.thisMonthExpenseAmount,
      'thisMonthIncomeAmount': instance.thisMonthIncomeAmount,
      'previousMonthExpenseAmount': instance.previousMonthExpenseAmount,
      'previousMonthIncomeAmount': instance.previousMonthIncomeAmount,
    };
