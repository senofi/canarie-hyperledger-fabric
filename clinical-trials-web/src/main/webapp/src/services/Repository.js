import axios from "axios";
import { LocalStorage } from "quasar";

const ajax = axios.create({
  baseURL: process.env.API
});

ajax.interceptors.request.use(
  config => {
    const user = LocalStorage.getItem("user");

    if (user) {
      config.headers["Authorization"] = `Basic ${user.authdata}`;
    }
    return config;
  },

  error => {
    return Promise.reject(error);
  }
);

export default ajax;
