<template>
  <q-page class="flex flex-center">
    <div class="column stretch" style="max-width: 400px; min-width: 300px">
      <p class="text-h4" align="center">Login</p>
      <q-form @submit="handleSubmit" ref="loginForm" autocomplete="off">
        <q-input
          filled
          name="username"
          type="text"
          v-model="username"
          label="Username"
          :rules="[val => !!val || 'Username is required']"
        />
        <q-input
          filled
          type="password"
          v-model="password"
          label="Password"
          :rules="[val => !!val || 'Password is required']"
        />
        <q-btn
          color="primary"
          type="submit"
          :loading="loading"
          style="width: 100%"
          >Login</q-btn
        >
      </q-form>
    </div>
  </q-page>
</template>

<script>
import { mapState, mapActions } from "vuex";

export default {
  data() {
    return {
      username: "",
      password: "",
      loading: false,
      returnUrl: ""
    };
  },
  mounted() {
    this.signOutUser();
  },
  computed: {
    ...mapState("ui", ["userLoggedIn"])
  },
  methods: {
    ...mapActions("ui", ["logInUser", "notifyError", "signOutUser"]),
    handleSubmit() {
      this.$refs.loginForm.validate().then(success => {
        if (success) {
          this.loading = true;
          this.logInUser({
            username: this.username,
            password: this.password
          })
            .then(() => this.$router.push("/app/trials"))
            .catch(err => {
              this.loading = false;
              this.notifyError(err);
            });
        }
      });
    }
  }
};
</script>
