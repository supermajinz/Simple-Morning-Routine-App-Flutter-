// ignore_for_file: unused_local_variable, prefer_const_constructors, must_be_immutable, overridden_fields, prefer_const_literals_to_create_immutables

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class AppModel extends ChangeNotifier{
  Routine myRoutine = Routine([
  Habit("Cold Shower", 15),
  Habit("Plan Day", 5),
  Habit("Make Bed", 1),
  Habit("Do Pushups", 5)
]);
List<Habit> primaryHabits = [
  Habit("Cold Shower", 15),
  Habit("Plan Day", 5),
  Habit("Make Bed", 1),
  Habit("Do Pushups", 5),
  Habit("Drink Water", 15),
  Habit("Gratituide", 5),
  Habit("Brush Teeth", 1),
  Habit("Meditate", 5)
];

//add habit to routine
void addHabit(Habit habit){
  myRoutine.habits.add(Habit(habit.name,habit.duration));
  notifyListeners();
}
//delete habit from routine
void deleteHabit(int index){
  myRoutine.habits.removeAt(index);
  notifyListeners();
}
//modify habit from routine
void modifyHabits(String habitName,int duration,Habit habit){
    int index = myRoutine.habits.indexOf(habit);
    myRoutine.habits[index]= Habit(habitName,duration);
    notifyListeners();

}
//reorder habits in routine
void reOrderHabits(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }
      //remove at oldindex and hold in temp
      final Habit temp = myRoutine.habits.removeAt(oldIndex);
      //insert temp at new index
      myRoutine.habits.insert(newIndex, temp);
      notifyListeners();
  }
//add habit to default list
void addDefaultHabit(Habit habit){
  primaryHabits.add(Habit(habit.name,habit.duration));
  notifyListeners();
}
//delete habit from default list
void deleteDefaultHabit(int index){
  primaryHabits.removeAt(index);
  notifyListeners();
}
//modify habit in default list
void modifyDefaultHabit(String habitName,int duration,Habit habit){
  int index = primaryHabits.indexOf(habit);
  primaryHabits[index]= Habit(habitName,duration);
  notifyListeners();

}


}
class Habit {
   String name;
   int duration;
 

  Habit(this.name, this.duration);
}

class Routine {
  List<Habit> habits;

  Routine(this.habits);

  int getDuration() {
    return habits.fold(
        0, (totalDuration, habit) => totalDuration + habit.duration);
  }

  int getHabitsQuantity() {
    return habits.length;
  }
}

class MyHome extends StatelessWidget {
   const MyHome({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Morning Routine"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => AddHabits())));
            },
            icon: Icon(Icons.add),
          ),

        ],
        backgroundColor: Colors.blue,
      ),
      body: Provider.of<AppModel>(context,listen: true).myRoutine.habits.isNotEmpty?
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Center(
              child: ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: ((context)=>RoutineStartScreen()))), child: Text("Start"))),
          SizedBox(
            height: 10,
          ),
          Consumer<AppModel>(
            builder: (BuildContext context, AppModel data, Widget? child) { return Text("${data.myRoutine.getHabitsQuantity()} habits \n   "
                "${data.myRoutine.getDuration()}m"); },
          ),
          Expanded(
            child:  MyRoutineList(),
          )
        ],
      )
      :
    Center(child: Text("You dont have any morning routine habits."))
    );
  }
}

class MyRoutineList extends StatefulWidget {
  const MyRoutineList({
    super.key,
  });

  
  

  @override
  State<MyRoutineList> createState() => _MyRoutineListState();
}

class _MyRoutineListState extends State<MyRoutineList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (BuildContext context, AppModel data, Widget? child) {
        return ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            data.reOrderHabits(oldIndex, newIndex);
          },

          children: data.myRoutine.habits.asMap().entries.map((entry) {
            final index = entry.key;
            final habit = entry.value;
            return Dismissible(
              key:UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16.0),
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                data.deleteHabit(index);
              },
              child: ListTile(
                title: Text(habit.name),                contentPadding: EdgeInsets.all(8),
                leading: Text("${habit.duration}m"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => HabitModifyScreen(habit: habit)),
                    ),
                  );
                }, //edit
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
    create: (context) => AppModel(),
    child: MaterialApp(
      home: MyHome(),
    ),
  ));
}

class AddHabits extends StatelessWidget {

  const AddHabits({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Add Habits"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HabitAddScreen(
                                habit: Habit("Name", 0),
                      
                              )));
                },
                icon: Icon(Icons.add))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: 
        Consumer<AppModel>(
  builder: (BuildContext context, AppModel data, Widget? child) {
    return ListView(
      children: data.primaryHabits.asMap().entries.map((entry) {
        final int index = entry.key;
        final Habit habit = entry.value;

        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            data.deleteDefaultHabit(index);
          },
          child: ListTile(
            title: Text(habit.name),
            subtitle: Text("${habit.duration}m"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DefaultHabitModifyScreen(habit: habit),
                ),
              );
            },
            leading: IconButton(
              onPressed: () {
                data.addHabit(habit);
              },
              icon: Icon(Icons.add),
            ),
          ),
        );
      }).toList(),
    );
  },
)
        );
  }
}

class HabitModifyScreen extends StatelessWidget {
  final Habit habit;
  final String title="Edit Habit";
   HabitModifyScreen(
      {required this.habit, super.key});
  late String habitName=habit.name;
  late int duration= habit.duration;
  void applyChange(context){
       Provider.of<AppModel>(context,listen: false).modifyHabits(habitName, duration, habit);
              Navigator.pop(context);
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)),
            actions:  [IconButton(onPressed: (){
                applyChange(context);
              } ,
               icon: Icon(Icons.check))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Name"),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) => habitName=value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: habit.name),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text("Duration"),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              onTimerDurationChanged: (value) {duration=value.inMinutes;},
              initialTimerDuration: Duration(minutes: habit.duration),
            ),
          )
        ],
      ),
    );
  }
}
class HabitAddScreen extends HabitModifyScreen{
  HabitAddScreen({super.key, required super.habit,});
  @override
  final title = "Add Habit";
  @override
  void applyChange(context){
     Provider.of<AppModel>(context,listen: false).addDefaultHabit(Habit(habitName,duration));
              Navigator.pop(context);
  }
}

class DefaultHabitModifyScreen extends HabitModifyScreen{
  DefaultHabitModifyScreen({super.key, required super.habit});

  @override
  void applyChange(context){
     Provider.of<AppModel>(context,listen: false).modifyDefaultHabit(habitName, duration, habit);
              Navigator.pop(context);
  }
  
}

class RoutineStartScreen extends StatelessWidget {

  const RoutineStartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.close)),
        title: Text("Morning Routine"),
        centerTitle: true,
      ),
      body: RoutineTimer()
    );
  }
}
class RoutineTimer extends StatefulWidget {
  const RoutineTimer({super.key});

  @override
  State<RoutineTimer> createState() => _RoutineTimerState();
}

class _RoutineTimerState extends State<RoutineTimer> {
  late List<Habit> activeRoutine;
  late Habit activeHabit;
  late CountDownController myController;
  late String habitName;
  late int routineDuration;
  IconData pauseIcon = Icons.pause;
  double progressIndicator = 0;
  @override
  void initState() {
    super.initState();
    // Initialize the variables in initState
    activeRoutine = List.from(Provider.of<AppModel>(context, listen: false).myRoutine.habits);
    routineDuration =Provider.of<AppModel>(context, listen: false).myRoutine.getDuration();
    activeHabit = activeRoutine[0];
    myController = CountDownController();
    habitName = activeHabit.name;
  }
  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat('HH:mm').format(DateTime.now())),  
              Expanded(child: LinearProgressIndicator(value:progressIndicator)),
              Text(DateFormat('HH:mm').format(DateTime.now().add(Duration(minutes: routineDuration)))),
            ],
          ),
          Text(habitName),
          SizedBox(height: 20,),
          Expanded(
            child: CircularCountDownTimer(width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.8, duration: activeHabit.duration, fillColor: Colors.white , ringColor: Colors.blue,isReverse: true, isReverseAnimation: true,
            controller: myController,
            onComplete: habitFinished
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 40,),
              IconButton(onPressed: pauseAndPlay, icon: Icon(pauseIcon)),
              IconButton(onPressed: skip, icon: Icon(Icons.skip_next))
            ],
          ),
        ],
      );
  }
  void habitFinished(){
    setState(() {
            
            progressIndicator += activeHabit.duration/routineDuration;
            activeRoutine.removeAt(0);
            if(activeRoutine.isNotEmpty){
            activeHabit = activeRoutine[0];
            habitName = activeHabit.name;
            myController.restart(duration: activeHabit.duration);
            }
            else {
              Navigator.pop(context);
            }
          }); 
  }
  void pauseAndPlay(){
    setState(() {
      if(myController.isPaused) {
        myController.resume();
        pauseIcon = Icons.pause;
      } else {
        myController.pause();
        pauseIcon  = Icons.play_arrow;
      }
    });
  }
  
  //skip
  void skip(){
    habitFinished();
  }
}