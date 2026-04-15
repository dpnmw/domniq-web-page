import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "dwp-admin-nav",
  initialize(container) {
    const currentUser = container.lookup("service:current-user");
    if (!currentUser?.admin) return;
    withPluginApi((api) => {
      api.addAdminPluginConfigurationNav("domniq-web-page", [
        { label: "dwp.admin.overview_title", route: "adminPlugins.show.dwp-overview" },
        { label: "dwp.admin.general_title",  route: "adminPlugins.show.dwp-general"  },
        { label: "dwp.admin.design_title",   route: "adminPlugins.show.dwp-design"   },
        { label: "dwp.admin.sections_title", route: "adminPlugins.show.dwp-sections" },
        { label: "dwp.admin.navbar_title",   route: "adminPlugins.show.dwp-navbar"   },
        { label: "dwp.admin.footer_title",   route: "adminPlugins.show.dwp-footer"   },
        { label: "dwp.admin.support_title",  route: "adminPlugins.show.dwp-support"  },
      ]);
    });
  },
};
