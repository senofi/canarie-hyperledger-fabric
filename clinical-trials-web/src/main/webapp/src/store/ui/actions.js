import {
  SET_USER_LOGGED_IN,
  OPERATION_IN_PROGRESS,
  SET_ERROR,
  SET_USERNAME
} from "../mutation-types";
import { userService } from "@/services/UserService";

export function logInUser({ commit }, data) {
  const { username, password } = data;
  commit(OPERATION_IN_PROGRESS, true);
  let result = "";
  try {
    result = userService.login(username, password);
    commit(SET_USER_LOGGED_IN, true);
    commit(SET_USERNAME, username);
    return result;
  } finally {
    commit(OPERATION_IN_PROGRESS, false);
  }
}

export function checkUserLoginStatus({ commit }) {
  const user = userService.getUser();
  if (user) {
    commit(SET_USER_LOGGED_IN, true);
    commit(SET_USERNAME, user.principal.username);
  }
}

export function getUser() {
  return userService.getUser();
}

export function signOutUser({ commit }) {
  userService.logout();
  commit(SET_USER_LOGGED_IN, false);
}

export function notifyError({ commit }, error) {
  commit(SET_ERROR, error);
}

export function resetError({ commit }) {
  commit(SET_ERROR, "");
}
