<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          @click="leftDrawerOpen = !leftDrawerOpen"
          icon="menu"
          aria-label="Menu"
        />

        <q-toolbar-title>
          {{ $route.meta.title }}
        </q-toolbar-title>
        <q-space />
        <template v-if="userLoggedIn">
          <q-btn-dropdown stretch flat icon="account_circle">
            <q-list>
              <q-item clickable v-close-popup tabindex="0">
                <q-item-section>
                  <q-item-label caption>
                    Username
                  </q-item-label>
                  <q-item-label lines="1">{{ username }}</q-item-label>
                </q-item-section>
              </q-item>
              <q-separator inset spaced />
              <q-item clickable v-close-popup tabindex="0" @click="signOut">
                <q-item-section>
                  <q-item-label>Sign Out</q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-btn-dropdown>
        </template>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      content-class="bg-grey-2"
    >
      <q-list>
        <div class="justify-center row">
          <img
            :src="`statics/${$config.logo}`"
            :alt="`${$config.companyName}`"
            style="width: 80%;"
            class="logo"
          />
        </div>
        <q-separator />
        <q-item-label header>Menu</q-item-label>
        <q-item
          clickable
          @click="$router.push('/app/trials')"
          :active="$router.currentRouter === '/app/trials' ? 'active' : ''"
        >
          <q-item-section avatar>
            <q-icon name="local_hospital" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Trial Cases</q-item-label>
            <q-item-label caption>Clinical trial cases</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <template v-if="hasAccess">
        <router-view />
      </template>
    </q-page-container>
  </q-layout>
</template>

<script>
import { mapState, mapActions } from "vuex";

export default {
  name: "AppLayout",

  data() {
    return {
      leftDrawerOpen: false
    };
  },
  methods: {
    ...mapActions("ui", [
      "resetError",
      "signOutUser",
      "getUser",
      "checkUserLoginStatus"
    ]),
    mounted() {
      this.resetError();
    },
    signOut() {
      this.signOutUser();
      this.$router.push("/login");
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
    },
    loading: {
      immediate: true,
      handler: function(value) {
        value
          ? this.$q.loading.show({
              messageColor: "white",
              message: "Loading..."
            })
          : this.$q.loading.hide();
      }
    }
  },
  computed: {
    ...mapState("ui", ["userLoggedIn", "error", "username", "loading"]),
    hasAccess: function() {
      return this.$route.meta.isPublic || this.userLoggedIn;
    }
  },
  beforeRouteEnter(to, from, next) {
    next(async vm => {
      vm.checkUserLoginStatus();
      if (!vm.userLoggedIn) {
        if (vm.$router.currentRouter !== "/login") {
          vm.$router.push("/login");
        }
      }
    });
  }
};
</script>
