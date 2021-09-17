import TrialRepository from "@/services/TrialRepository";
import { OPERATION_IN_PROGRESS, SET_TRIALS } from "../mutation-types";

export async function createTrial({ commit }, payload) {
  commit(`ui/${OPERATION_IN_PROGRESS}`, true, { root: true });
  try {
    await TrialRepository.create(payload);
  } finally {
    commit(`ui/${OPERATION_IN_PROGRESS}`, false, { root: true });
  }
}

export async function updateTrial({ commit }, data) {
  const { caseId, status } = data;
  commit(`ui/${OPERATION_IN_PROGRESS}`, true, { root: true });
  try {
    await TrialRepository.update(caseId, status);
  } finally {
    commit(`ui/${OPERATION_IN_PROGRESS}`, false, { root: true });
  }
}

export async function getTrials({ commit }) {
  commit(`ui/${OPERATION_IN_PROGRESS}`, true, { root: true });
  try {
    const { data } = await TrialRepository.get();
    commit(SET_TRIALS, data);
  } finally {
    commit(`ui/${OPERATION_IN_PROGRESS}`, false, { root: true });
  }
}
