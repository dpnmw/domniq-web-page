import Component from "@glimmer/component";

export default class DwpUploadNote extends Component {
  <template>
    <div class="dwp-upload-note">
      <span>{{@fieldName}} image is managed in the </span>
      <a href="/admin/site_settings?filter=domniq_web">Settings tab</a>
    </div>
  </template>
}
