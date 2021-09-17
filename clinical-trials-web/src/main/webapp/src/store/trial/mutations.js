import { SET_TRIALS } from "../mutation-types";

export default {
  [SET_TRIALS](state, data) {
    state.trials = data;
  }
};
