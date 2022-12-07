import 'package:flutter/material.dart';

class Student {
  String title;
  String description;
  String imageUrl;
  String year;

  Student(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.year});
}

List<Student> studentList = [
  Student(
    title: 'Sarah Pirzada',
    description: 'add transcript',
    year: 'FA21-BSCS-018',
    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
  ),
  Student(
    title: 'Moin ud Din',
    description: 'add transcript',
    year: 'FA19-BSCS-016',
    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
  ),
  Student(
    title: 'Natasha Komal',
    description: 'add transcript',
    year: 'FA19-BSCS-027',
    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
  ),
  Student(
    title: "Muhammad Sharyar",
    year: 'FA19-BSCS-003',
    description: 'add transcript',
    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
  ),
  Student(
    title: "Abdul Wasay",
    year: 'FA19-BSCS-007',
    description: 'add transcript',
    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
  ),
  Student(
    title: "Aliya Pirzada",
    year: 'FA19-BSCS-029',
    description: 'add transcript',
    imageUrl: 'https://picsum.photos/seed/picsum/200/300',
  )
];
