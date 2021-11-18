const routes = [
  {
    path: "/app",
    component: () => import("layouts/AppLayout.vue"),
    children: [
      {
        path: "trials",
        component: () => import("pages/Trials.vue"),
        meta: { title: "Trial Cases" }
      },
      {
        path: "trials/create",
        component: () => import("pages/TrialCreate.vue"),
        meta: { title: "Record New Case" }
      }
    ]
  },
  {
    path: "/",
    component: () => import("layouts/LandingLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/Home.vue"),
        meta: { isPublic: true }
      },
      {
        path: "login",
        component: () => import("pages/Login.vue"),
        meta: { isPublic: true }
      }
    ]
  }
];

// Always leave this as last one
if (process.env.MODE !== "ssr") {
  routes.push({
    path: "*",
    component: () => import("pages/Error404.vue")
  });
}

export default routes;
