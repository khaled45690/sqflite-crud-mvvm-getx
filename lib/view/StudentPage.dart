import 'package:flutter/material.dart';
import 'package:flutter_sqflite/model/StudentModel.dart';
import 'package:flutter_sqflite/view_model/StudentViewModel.dart';
import 'package:get/get.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final studentViewModel = Get.put(StudentViewModel());
  final nameController = TextEditingController();
  int? studentId;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Obx(() => Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: isEditing ? cancelEditing  : add,
                        child: isEditing ? const Text("cancel editing") : const Text("Add")),
                    SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                        onPressed: isEditing
                            ? () {
                                if (nameController.text != "") {
                                  studentViewModel.updateStudent(StudentModel(
                                      id: studentId,
                                      name: nameController.text));
                                  nameController.text = "";
                                  isEditing = false;
                                  setState(() {});
                                }
                              }
                            : null,
                        child: Text("Update"))
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: studentViewModel.allStudent.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              studentId =
                                  studentViewModel.allStudent[index].id!;
                              nameController.text =
                                  studentViewModel.allStudent[index].name!;
                              isEditing = true;
                              setState(() {});
                            },
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(studentViewModel
                                          .allStudent[index].name!),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        studentViewModel.deleteStudent(
                                            studentViewModel
                                                .allStudent[index].id!);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 32,
                                      ))
                                ],
                              ),
                            ),
                          );
                        }))
              ],
            ),
          )),
    ));
  }


  add(){
    if (nameController.text != "") {
      studentViewModel.addStudent(StudentModel(
          id: null, name: nameController.text));
      nameController.text = "";
    }
  }

  cancelEditing(){
    isEditing = false;
    setState(() {});
  }
}
