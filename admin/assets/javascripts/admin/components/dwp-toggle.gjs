import Component from "@glimmer/component";
import { on } from "@ember/modifier";

export default class DwpToggle extends Component {
  handleChange = (event) => {
    this.args.onChange?.(event.target.checked);
  };

  <template>
    <label class="dwp-toggle">
      <input type="checkbox" checked={{@checked}} {{on "change" this.handleChange}} />
      <span class="dwp-toggle__track"></span>
    </label>
  </template>
}
