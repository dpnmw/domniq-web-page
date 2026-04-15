import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { on } from "@ember/modifier";
import { htmlSafe } from "@ember/template";
import { getIcon } from "./dwp-icons";
import DwpLicenseLock from "./dwp-license-lock";

export default class DwpAccordion extends Component {
  @tracked isOpen = this.args.open ?? false;

  @action
  toggle() {
    this.isOpen = !this.isOpen;
  }

  get iconHtml() {
    if (!this.args.icon) return null;
    return htmlSafe(getIcon(this.args.icon));
  }

  get toggleHtml() {
    return htmlSafe(this.isOpen ? getIcon("xmark") : getIcon("plus"));
  }

  <template>
    <div class="dwp-accordion {{if this.isOpen 'dwp-accordion--open'}}">
      <button class="dwp-accordion__header" type="button" {{on "click" this.toggle}}>
        <span class="dwp-accordion__title">
          {{#if this.iconHtml}}
            <span class="dwp-accordion__icon">{{this.iconHtml}}</span>
          {{/if}}
          {{@title}}
          {{#if @locked}}
            <span class="dwp-accordion__lock-badge">Licence Required</span>
          {{/if}}
        </span>
        <span class="dwp-accordion__toggle">{{this.toggleHtml}}</span>
      </button>
      {{#if this.isOpen}}
        <div class="dwp-accordion__body {{if @dimmed 'dwp-accordion__body--dimmed'}}">
          {{#if @locked}}
            <div class="dwp-accordion__body-locked">
              {{yield}}
              <DwpLicenseLock />
            </div>
          {{else}}
            {{yield}}
          {{/if}}
        </div>
      {{/if}}
    </div>
  </template>
}
