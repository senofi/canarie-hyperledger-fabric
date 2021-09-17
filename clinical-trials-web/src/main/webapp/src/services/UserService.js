import Repository from "./Repository";
import { LocalStorage } from "quasar";

export const userService = {
  login,
  logout,
  getUser
};

async function login(username, password) {
  const requestOptions = {
    headers: {
      Authorization: "Basic " + window.btoa(username + ":" + password)
    }
  };

  return Repository.get("/user", requestOptions)
    .then(handleResponse)
    .then(user => {
      // login successful if there's a user in the response
      if (user) {
        // store user details and basic auth credentials in local storage
        // to keep user logged in between page refreshes
        user.authdata = window.btoa(username + ":" + password);
        LocalStorage.set("user", user);
      }

      return user;
    });
}

function getUser() {
  return LocalStorage.getItem("user");
}

function logout() {
  // remove user from local storage to log user out
  LocalStorage.remove("user");
}

function handleResponse(response) {
  if (response.status !== 200) {
    if (response.status === 401) {
      // auto logout if 401 response returned from api
      logout();
      location.reload(true);
    }

    return Promise.reject(response);
  }
  const { data } = response;

  return data;
}
