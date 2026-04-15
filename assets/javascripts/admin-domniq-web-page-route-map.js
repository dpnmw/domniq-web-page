export default {
  resource: "admin.adminPlugins.show",
  path: "/plugins",
  map() {
    this.route("dwp-overview");
    this.route("dwp-general");
    this.route("dwp-design");
    this.route("dwp-sections");
    this.route("dwp-navbar");
    this.route("dwp-footer");
    this.route("dwp-support");
  },
};
