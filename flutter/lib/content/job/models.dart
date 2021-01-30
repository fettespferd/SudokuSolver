import 'package:sudokuSolver/app/module.dart';

part 'models.freezed.dart';

@freezed
abstract class Job extends Entity implements _$Job {
  const factory Job({
    String name,
    String industry,
    String requiredDegree,
    String procedure,
    String suitability,
    String tasks,
    String tips,
    String type,
    String duration,
    List<String> workingHours,
    List<String> workingLocation,
    List<String> furtherEducation,
    List<int> earnings,
  }) = _Job;

  const Job._();

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      name: json['name'] as String,
      industry: json['industry'] as String,
      requiredDegree: json['requiredDegree'] as String,
      procedure: json['procedure'] as String,
      suitability: json['suitability'] as String,
      tasks: json['tasks'] as String,
      tips: json['tips'] as String,
      type: json['type'] as String,
      duration: json['duration'] as String,
      workingHours: json['workingHours']?.cast<String>() as List<String>,
      workingLocation: json['workingLocation']?.cast<String>() as List<String>,
      furtherEducation:
          json['furtherEducation']?.cast<String>() as List<String>,
      earnings: json['earnings']?.cast<int>() as List<int>,
    );
  }
  static final collection = services.firebaseFirestore.collection('jobsData');

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'industry': industry,
      'requiredDegree': requiredDegree,
      'procedure': procedure,
      'suitability': suitability,
      'tasks': tasks,
      'tips': tips,
      'type': type,
      'duration': duration,
      'workingHours': workingHours,
      'workingLocation': workingLocation,
      'furtherEducation': furtherEducation,
      'earnings': earnings,
    };
  }
}
