<template>
  <q-page class="q-pa-md flex-box column">
    <div class="q-pa-md q-gutter-md">
      <q-card class="my-card">
        <q-card-section
          class="justify-end"
          style="display:flex;flex-direction:row;"
        >
          <q-btn
            v-if="isAllowedToRecordCase()"
            color="primary"
            @click="$router.push('/app/trials/create')"
            >Record New Case</q-btn
          >
        </q-card-section>
        <q-table
          dense
          table-header-class="grey-8 align-center"
          :data="trials"
          :columns="trialColumns"
          row-key="name"
        >
          <template v-slot:body="props">
            <q-tr :props="props">
              <q-td key="caseId" :props="props">{{ props.row.caseId }}</q-td>
              <q-td key="subjectName" :props="props">{{
                props.row.subjectName
              }}</q-td>
              <q-td key="description" :props="props">{{
                props.row.description
              }}</q-td>
              <q-td key="siteName" :props="props">
                {{ props.row.siteName }}
              </q-td>
              <q-td key="submissionDate" :props="props">
                {{ formatDate(props.row.submissionDate) }}
              </q-td>
              <q-td key="status" :props="props">{{
                getStatusLabel(props.row.status)
              }}</q-td>

              <q-td key="actions" :props="props">
                <q-btn
                  color="secondary"
                  @click="acceptTrialCase(props.row.caseId)"
                  v-if="isAcceptEnabled(props.row.status)"
                >
                  Accept
                  <q-tooltip>Accept this trial case</q-tooltip>
                </q-btn>
                <q-btn
                  color="secondary"
                  @click="changeStatus(props.row.caseId, 'INPROCESS')"
                  v-if="
                    isActionEnabled(
                      props.row.caseId,
                      props.row.status,
                      'INPROCESS'
                    )
                  "
                >
                  Investigate
                  <q-tooltip>Investigate this trial case</q-tooltip>
                </q-btn>
                <q-btn
                  color="secondary"
                  @click="changeStatus(props.row.caseId, 'CLOSED')"
                  v-if="
                    isActionEnabled(props.row.id, props.row.status, 'CLOSED')
                  "
                >
                  Close
                  <q-tooltip>Close this trial case</q-tooltip>
                </q-btn>
              </q-td>
            </q-tr>
          </template>
        </q-table>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { mapState, mapActions } from "vuex";
import { date } from "quasar";

export default {
  name: "Trials",
  data() {
    return {
      trialColumns: [
        {
          name: "caseId",
          label: "Case Id",
          field: "caseId",
          align: "left",
          sortable: true
        },
        {
          name: "subjectName",
          label: "Patient Name",
          field: "subjectName",
          align: "left",
          sortable: true
        },
        {
          name: "description",
          label: "Description",
          field: "description",
          align: "left",
          sortable: true
        },
        {
          name: "siteName",
          label: "Site",
          field: "siteName",
          align: "left",
          sortable: true
        },
        {
          name: "submissionDate",
          label: "Reported On",
          field: "submissionDate",
          align: "left",
          sortable: true
        },
        {
          name: "status",
          label: "Status",
          field: "status",
          align: "left",
          sortable: true
        },
        {
          name: "actions",
          label: "Actions",
          align: "right"
        }
      ],
      statusTransitions: {
        NEW: "INPROCESS",
        INPROCESS: "CLOSED",
        CLOSED: "ACCEPTED"
      },
      statusToLabel: {
        NEW: "New",
        INPROCESS: "Investigation In Process",
        CLOSED: "Closed",
        ACCEPTED: "Regulator Accepted"
      }
    };
  },
  computed: {
    ...mapState("trial", ["trials"])
  },
  methods: {
    ...mapActions("trial", ["getTrials", "updateTrial"]),
    ...mapActions("ui", ["notifyError"]),
    acceptTrialCase(caseId) {
      this.updateTrial({ caseId: caseId, status: "ACCEPTED" }).then(() =>
        this.fetch()
      );
    },
    isAcceptEnabled(status) {
      return status === "CLOSED" && this.$config.allow_accept;
    },
    changeStatus(caseId, status) {
      this.updateTrial({ caseId: caseId, status: status }).then(() =>
        this.fetch()
      );
    },
    isActionEnabled(caseId, oldStatus, requestedStatus) {
      const allowedTransition = this.statusTransitions[oldStatus];
      return this.$config.allow_update && allowedTransition === requestedStatus;
    },
    isAllowedToRecordCase() {
      return this.$config.allow_create;
    },
    fetch() {
      try {
        this.getTrials();
      } catch (err) {
        this.notifyError(err);
      }
    },
    getStatusLabel(statusCode) {
      const label = this.statusToLabel[statusCode];
      return label ? label : statusCode;
    },
    formatDate(timeStamp) {
      return date.formatDate(timeStamp, "YYYY-MM-DD");
    }
  },
  mounted() {
    this.fetch();
  }
};
</script>
