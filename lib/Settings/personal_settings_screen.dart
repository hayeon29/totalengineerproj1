import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { Man, Woman }
//TODO:Gender Flag로 만들어서 bool타입으로 관리할 것

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({Key? key}) : super(key: key);

  @override
  _PersonalSettingsState createState() => _PersonalSettingsState();
}

class _PersonalSettingsState extends State<PersonalSettings> {
  var _selectedYear = '1970';
  final _yearList = [
    '1921',
    '1922',
    '1923',
    '1924',
    '1925',
    '1926',
    '1927',
    '1928',
    '1929',
    '1930',
    '1931',
    '1932',
    '1933',
    '1934',
    '1935',
    '1936',
    '1937',
    '1938',
    '1939',
    '1940',
    '1941',
    '1942',
    '1943',
    '1944',
    '1945',
    '1946',
    '1947',
    '1948',
    '1949',
    '1950',
    '1951',
    '1952',
    '1953',
    '1954',
    '1955',
    '1956',
    '1957',
    '1958',
    '1959',
    '1960',
    '1961',
    '1962',
    '1963',
    '1964',
    '1965',
    '1966',
    '1967',
    '1968',
    '1969',
    '1970',
    '1971',
    '1972',
    '1973',
    '1974',
    '1975',
    '1976',
    '1977',
    '1978',
    '1979',
    '1980',
    '1981',
    '1982',
    '1983',
    '1984',
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020'
  ];
  var _selectedMonth = '1';
  final _monthList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  var _selectedDate = '1';
  final _dateList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];

  Gender _gender = Gender.Man;

  void _setData(String value1, Gender value2) async {
    var keyBdate = 'BDate';
    var keyGen = 'Gender';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(keyBdate, value1);
    pref.setString(keyGen, value2.toString());
  }

  void _loadData() async {
    var keyBDate = 'BDate';
    var keyGen = 'Gender';
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var value1 = pref.getString(keyBDate);
      //TODO:전달받은 value값 분해해서 _selectedDate, _seletedMonth, _selectedYear변수에 집어넣기
      var value2 = pref.getString(keyGen);
      value2 = _gender as String?;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _setPersonalSettings() {
    setState(() {
      _setData('$_selectedDate - $_selectedMonth - $_selectedYear', _gender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('개인정보 설정')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('생년월일'),
          Row(
            children: <Widget>[
              Container(
                width: 100,
                child: DropdownButtonFormField(
                  value: _selectedYear,
                  items: _yearList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value.toString();
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                child: DropdownButtonFormField(
                  value: _selectedMonth,
                  items: _monthList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value.toString();
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                child: DropdownButtonFormField(
                  value: _selectedDate,
                  items: _dateList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDate = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          Text('성별'),
          Row(
            children: <Widget>[
              Container(
                width: 150,
                child: RadioListTile(
                  title: Text('남성'),
                  value: Gender.Man,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = Gender.Man;
                    });
                  },
                ),
              ),
              Container(
                  width: 150,
                  child: RadioListTile(
                      title: Text('여성'),
                      value: Gender.Woman,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = Gender.Woman;
                        });
                      })
              ),
            ],
          ),
          Text('gender: $_gender, Birth: $_selectedDate - $_selectedMonth - $_selectedYear')
        ],
      ),
      /*
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text('생년월일'),
                DropdownButtonFormField(
                  value: _selectedValue,
                  items: _valueList.map(
                        (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value.toString();
                    });
                  },
                ),

            Text('성별'),
            RadioListTile(
              title:Text('남성'),
              value: Gender.Man,
              groupValue: _gender,
              onChanged: (value) {
                  setState(() {
                    _gender = Gender.Man;
                  });
              },
            ),
            RadioListTile(
                title:Text('여성'),
                value: Gender.Woman,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = Gender.Woman;
                  });
                })

          ],
        )
      )
        */
    );
  }
}
