class ApiUrls {
  static const routeUrl = "https://expense-income007.herokuapp.com/";
}

class Authentication {
  static const register = "user/register";
  static const login = "user/login";
  static const googleSignIn = "user/googleSignIn";
}

class AchievementUrls {
  static const getAllAchievements = "achievement/getAll";
}

class ExpenseUrls {
  static const addExpense = "expense/add";
  static const getExpenseDWM = "expense/getDWM";
  static const getExpenseSpecific = "expense/getSpecific";
  static const removeExpense = "expense/remove";
  static const editExpense = "expense/edit";
  static const getCategorizedExpense = "expense/categorized";
  static const getCategorizedSpecificExpense = "expense/categorizedSpecific";
  static const getCategoryStartDate = "expense/getCategoryStartDate";
}

class IncomeUrls {
  static const addIncome = "income/add";
  static const getIncomeDWM = "income/getDWM";
  static const getIncomeSpecific = "income/getSpecific";
  static const removeIncome = "income/remove";
  static const editIncome = "income/edit";
  static const getCategorizedIncome = "income/categorized";
  static const getCategorizedSpecificIncome = "income/categorizedSpecific";
  static const getCategoryStartDate = "income/getCategoryStartDate";
}

class HomeUrls {
  static const viewHome = "home/userData";
}

class ProgressUrls {
  static const getUserProgress = "progress/user";
  static const topUsersProgress = "progress/users";
  static const calculateProgress = "progress/userCalculateProgress";
}

class TokenUrls {
  static const generateToken = "token/generate";
  static const verifyToken = "token/verify";
}

class UserUrls {
  static const changePassword = "user/changePassword";
  static const checkPassword = "user/checkPassword";
  static const getUser = "user/view";
  static const changeProfilePicture = "user/changeProfilePicture";
  static const changeProfileInfo = "user/changeProfileInfo";
  static const publicProgress = "user/progressPublication";
}
