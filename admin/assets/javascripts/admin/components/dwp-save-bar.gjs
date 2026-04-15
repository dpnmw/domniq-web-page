import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import DButton from "discourse/components/d-button";

export default class DwpSaveBar extends Component {
  <template>
    <div class="dwp-save-bar">
      <DButton
        @label="dwp.admin.save"
        @icon="check"
        @disabled={{@saving}}
        {{on "click" @onSave}}
        class="btn-primary"
      />
      {{#if @saving}}
        <span class="dwp-save-bar__status">Saving...</span>
      {{else if @saved}}
        <span class="dwp-save-bar__status dwp-save-bar__status--done">Saved</span>
      {{/if}}
    </div>
  </template>
}
