<template>
  <q-page class="flex flex-center">
    <router-link to="login">
      <div class="row q-pa-md">
        <img style="max-height: 200px;" :src="`statics/${this.logo}`" />
      </div>
      <div class="row q-pa-md">
        <q-btn color="primary" style="width: 100%">Login</q-btn>
      </div>
    </router-link>
  </q-page>
</template>

<script>
export default {
  data() {
    return {
      logo: this.$config.logo
    };
  },
  created() {},
  computed: {},
  methods: {}
};
</script>
