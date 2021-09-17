<template>
  <q-page class="q-pa-md flex-box column">
    <div class="q-pa-md q-gutter-md">
      <q-form
        @submit="onSubmit"
        @reset="onReset"
        class="q-gutter-md"
        ref="createForm"
      >
        <q-card>
          <div style="padding: 0 20px 20px 20px;">
            <div class="q-gutter-md row">
              <div class="col-md-12">
                <q-input
                  outlined
                  v-model="name"
                  label="Patient Name *"
                  :rules="[
                    val => (val && val.length > 0) || 'This field is required.'
                  ]"
                />
              </div>
            </div>
            <div class="q-gutter-md row">
              <div class="col-md-12">
                <q-input
                  outlined
                  v-model="description"
                  label="Description *"
                  :rules="[
                    val => (val && val.length > 0) || 'This field is required.'
                  ]"
                />
              </div>
            </div>
            <div class="q-gutter-md row">
              <div class="col-md-12">
                <q-input
                  outlined
                  v-model="site"
                  label="Site *"
                  :rules="[
                    val => (val && val.length > 0) || 'This field is required.'
                  ]"
                />
              </div>
            </div>
          </div>
        </q-card>

        <q-card-actions align="between">
          <q-btn
            flat
            color="primary"
            class="button-cancel"
            @click="$router.back()"
            >Cancel</q-btn
          >
          <q-btn color="primary" style="width: 49%" @click="onSubmit(false)"
            >Record</q-btn
          >
        </q-card-actions>
      </q-form>
    </div>
  </q-page>
</template>

<style lang="stylus" scoped></style>

<script>
import { mapState, mapActions } from "vuex";

export default {
  name: "TrialCreate",
  data() {
    return {
      name: "",
      description: "",
      site: this.$config.companyName
    };
  },
  computed: {
    ...mapState("trial", ["trials"])
  },
  watch: {},
  methods: {
    ...mapActions("trial", ["createTrial"]),
    ...mapActions("ui", ["notifyError"]),
    async fetch() {
      await this.getTrials();
    },
    onSubmit() {
      this.$refs.createForm.validate().then(success => {
        if (success) {
          const payload = {
            subjectName: this.name,
            description: this.description,
            siteName: this.site
          };
          this.createTrial(payload)
            .then(() => {
              this.$q.notify({
                color: "green-4",
                textColor: "white",
                icon: "fas fa-check-circle",
                message: "Trial Case successfully recorded."
              });
              this.$router.back();
            })
            .catch(err => {
              this.notifyError(err);
            });
        }
      });
    },
    onReset() {}
  }
};
</script>
