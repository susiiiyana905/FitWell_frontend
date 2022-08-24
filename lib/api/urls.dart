class ApiUrls {
  static const routeUrl = "http://10.1.1.82:8001/";
}

class Authentication {
  static const register = "user/register";
  static const login = "user/login";
}

class TypeUrls {
  static const getExerciseTypes = "type/get";
}

class ExerciseUrls {
  static const getExercise = "exercise/get";
}

class StepUrls {
  static const getSteps = "step/add";
}

class HomeUrls {
  static const viewHome = "home/userData";
}

class CompletedUrls {
  static const getUserProgress = "completed/user";
  static const allProgress = "completed/viewRank";
}

class TokenUrls {
  static const generateToken = "token/generate";
  static const verifyToken = "token/verify";
}

class ProgressUrls {
  static const getUserProgress = "progress/user";
  static const topUsersProgress = "progress/users";
  static const calculateProgress = "progress/userCalculateProgress";
}

class UserUrls {
  static const changePassword = "user/changePassword";
  static const checkPassword = "user/checkPassword";
  static const getUser = "user/view";
  static const changeProfilePicture = "user/changeProfilePicture";
  static const changeProfileInfo = "user/changeProfileInfo";
  static const publicProgress = "user/progressPublication";
}
