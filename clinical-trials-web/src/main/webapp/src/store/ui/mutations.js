import {
  SET_ERROR,
  SET_USER_LOGGED_IN,
  OPERATION_IN_PROGRESS,
  SET_USERNAME
} from "../mutation-types";

export default {
  [SET_ERROR](state, error) {
    const messages = {
      http: {
        400: "Server responded with status 400",
        401: "Not authorized",
        403: "Forbidden",
        500: "Server responded with error"
      }
    };

    const { response } = error;
    if (response) {
      const { status } = response;
      const errMessages = messages;

      switch (status) {
        case 400:
          state.error = errMessages.http[400];
          break;
        case 401:
          state.error = errMessages.http[401];
          break;
        case 403:
          state.error = errMessages.http[403];
          break;
        case 500:
          state.error = errMessages.http[500];
          break;
        default:
          state.error = error.message;
      }
    } else {
      state.error = error;
    }
  },
  [SET_USER_LOGGED_IN](state, value) {
    state.userLoggedIn = value;
  },
  [OPERATION_IN_PROGRESS](state, value) {
    state.loading = value;
  },
  [SET_USERNAME](state, value) {
    state.username = value;
  }
};
