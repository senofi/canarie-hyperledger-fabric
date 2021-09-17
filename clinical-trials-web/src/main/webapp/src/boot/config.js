export default async ({ Vue }) => {
  Vue.prototype.$config = {
    ...process.env.APP_CONFIG
  };
};
