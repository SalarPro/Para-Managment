import 'package:flutter/material.dart';
import 'package:pare/src/models/category_model.dart';

class NewUserData {
  Future getCategoryList(BuildContext context) async {
    var dumpData = [
      {
        'uid': '0d7147d0-99b9-11ec-9697-65a337f27135',
        'emoji': '57662',
        'name': 'Gift',
        'type': 'both',
        'color': '#d66b1f'
      },
      {
        'uid': '29b8eca0-99b8-11ec-bdcd-afd3f860fc85',
        'emoji': '57816',
        'name': 'Car',
        'type': 'spend',
        'color': '#2466e3'
      },
      {
        'uid': '3fa1c000-99b8-11ec-a1bf-b363029ea84e',
        'emoji': '61827',
        'name': 'Entertainment',
        'type': 'spend',
        'color': '#fac61b'
      },
      {
        'uid': '6da0a700-99b8-11ec-b2bf-cd192668d5fe',
        'emoji': '57470',
        'name': 'Other',
        'type': 'both',
        'color': '#949494'
      },
      {
        'uid': '909d8fc0-99b8-11ec-b835-5b0171425c39',
        'emoji': '63695',
        'name': 'Salary',
        'type': 'income',
        'color': '#1ae41f'
      },
      {
        'uid': '9d1a4720-99b8-11ec-8be5-2189a3cd1ed8',
        'emoji': '59124',
        'name': 'Work',
        'type': 'income',
        'color': '#4acfa7'
      },
      {
        'uid': 'a306cec0-99b7-11ec-8e26-ffc65592e28a',
        'emoji': '62333',
        'name': 'Shopping',
        'type': 'spend',
        'color': '#ed109b'
      },
      {
        'uid': 'b80be830-969e-11ec-ba5b-73d3ee52cf37',
        'emoji': '63286',
        'name': 'Food & Drinks',
        'type': 'spend',
        'color': '#ecfd05'
      },
      {
        'uid': 'b8b46380-976a-11ec-9fdd-bffb9c9432c7',
        'emoji': '59312',
        'name': 'Bills & Fee',
        'type': 'spend',
        'color': '#0cc053'
      },
      {
        'uid': 'b9afef70-99b8-11ec-927e-c55fc88be9af',
        'emoji': '58513',
        'name': 'Extra income',
        'type': 'income',
        'color': '#99d611'
      },
      {
        'uid': 'bbfb3470-99b7-11ec-8d99-7fc503f5c1f8',
        'emoji': '60045',
        'name': 'Beauty',
        'type': 'spend',
        'color': '#b00ee6'
      },
      {
        'uid': 'd0c3f1d0-99b7-11ec-919a-aff834126b05',
        'emoji': '62552',
        'name': 'Transports',
        'type': 'spend',
        'color': '#23c3df'
      },
      {
        'uid': 'd8b670b0-99b8-11ec-9ca5-b3dfcdccc867',
        'emoji': '57627',
        'name': 'Business',
        'type': 'income',
        'color': '#0a47a0'
      },
      {
        'uid': 'f5c9f100-99b7-11ec-beec-5d9a5365cecb',
        'emoji': '63668',
        'name': 'Education',
        'type': 'spend',
        'color': '#32afdb'
      },
      {
        'uid': 'f62d5df0-95aa-11ec-98a9-335b7b82ddbb',
        'emoji': '63477',
        'name': 'Home',
        'type': 'spend',
        'color': '#c7b518'
      },
    ].map((e) => ParaCategory.fromMap(e)).toList();

    for (var element in dumpData) {
      await element.save(context);
    }
    return dumpData;
  }
}
