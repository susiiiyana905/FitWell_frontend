class ApiUrls {
  static const routeUrl = "https://fitwell.herokuapp.com/";
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
  static const getSteps = "step/get";
}

class HomeUrls {
  static const viewHome = "home/userData";
}

class CompletedUrls {
  static const completeExercise = "completed/add";
  static const myExercises = "completed/myExercises";
}

class TokenUrls {
  static const generateToken = "token/generate";
  static const verifyToken = "token/verify";
}

class ProgressUrls {
  static const getUserProgress = "progress/user";
  static const topUsersProgress = "progress/users";
}

class UserUrls {
  static const changePassword = "user/changePassword";
  static const checkPassword = "user/checkPassword";
  static const getUser = "user/view";
  static const changeProfilePicture = "user/changeProfilePicture";
  static const changeProfileInfo = "user/changeProfileInfo";
  static const publicProgress = "user/progressPublication";
}
