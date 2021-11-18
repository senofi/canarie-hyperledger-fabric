<template>
  <q-layout view="hHh lpR fFf">
    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { mapState, mapActions } from "vuex";

export default {
  data() {
    return {};
  },
  computed: {
    ...mapState("ui", ["error"])
  },
  methods: {
    ...mapActions("ui", ["resetError"]),
    mounted() {
      this.resetError();
    }
  },
  watch: {
    error: {
      immediate: true,
      handler: function(newErr) {
        if (newErr) {
          this.$q.notify({
            icon: "warning",
            message: newErr,
            color: "negative",
            html: true
          });
          this.resetError();
        }
      }
    }
  }
};
</script>
