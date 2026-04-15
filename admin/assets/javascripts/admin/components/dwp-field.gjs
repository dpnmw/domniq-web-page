import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import DwpToggle from "./dwp-toggle";

export default class DwpField extends Component {
  handleInput = (event) => {
    this.args.onChange?.(this.args.configKey, event.target.value);
  };

  handleToggle = (checked) => {
    this.args.onChange?.(this.args.configKey, String(checked));
  };

  handleColor = (event) => {
    this.args.onChange?.(this.args.configKey, event.target.value.replace("#", ""));
  };

  handleColorText = (event) => {
    this.args.onChange?.(this.args.configKey, event.target.value.replace("#", ""));
  };

  get isChecked() {
    return this.args.value === "true" || this.args.value === true;
  }

  get hexValue() {
    const v = this.args.value;
    return v && v !== "" ? `#${v.replace("#", "")}` : "#000000";
  }

  <template>
    {{#if (eq @type "bool")}}
      <DwpToggle @checked={{this.isChecked}} @onChange={{this.handleToggle}} />
    {{else if (eq @type "color")}}
      <div class="dwp-field__color-row">
        <input type="color" value={{this.hexValue}} class="dwp-field__color-picker" {{on "input" this.handleColor}} />
        <input type="text" value={{@value}} class="dwp-field__color-text" placeholder="hex" {{on "input" this.handleColorText}} />
      </div>
    {{else if (eq @type "integer")}}
      <input type="number" value={{@value}} min={{@min}} max={{@max}} class="dwp-field__input" {{on "input" this.handleInput}} />
    {{else if (eq @type "text_area")}}
      <textarea class="dwp-field__input dwp-field__textarea" {{on "input" this.handleInput}}>{{@value}}</textarea>
    {{else if (eq @type "enum")}}
      <select class="dwp-field__select" {{on "change" this.handleInput}}>
        {{#each @choices as |choice|}}
          <option value={{choice}} selected={{eq choice @value}}>{{choice}}</option>
        {{/each}}
      </select>
    {{else}}
      <input type="text" value={{@value}} class="dwp-field__input" {{on "input" this.handleInput}} />
    {{/if}}
  </template>
}

function eq(a, b) {
  return a === b;
}
