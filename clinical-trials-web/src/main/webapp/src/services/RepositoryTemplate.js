import Repository from "./Repository";

class RepositoryTemplate {
  constructor(resource) {
    this.resource = resource;
  }
  get() {
    return Repository.get(`${this.resource}`);
  }
  create(payload) {
    return Repository.post(`${this.resource}`, payload);
  }
  update(caseId, status) {
    return Repository.put(`${this.resource}/${caseId}/status/${status}`);
  }
  deleteById(id) {
    return Repository.delete(`${this.resource}/${id}`);
  }
  getById(id) {
    return Repository.get(`${this.resource}/${id}`);
  }
}

export default RepositoryTemplate;
