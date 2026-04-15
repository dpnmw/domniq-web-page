import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { on } from "@ember/modifier";

export default class DwpListEditor extends Component {
  get items() {
    const val = this.args.value;
    if (Array.isArray(val)) return val;
    if (typeof val === "string" && val.trim()) {
      try { return JSON.parse(val); } catch { return []; }
    }
    return [];
  }

  emit(newItems) {
    this.args.onChange?.(this.args.configKey, JSON.stringify(newItems));
  }

  @action
  updateField(index, fieldKey, event) {
    const items = [...this.items];
    items[index] = { ...items[index], [fieldKey]: event.target.value };
    this.emit(items);
  }

  @action
  addItem() {
    const empty = {};
    for (const f of this.args.fields) { empty[f.key] = ""; }
    this.emit([...this.items, empty]);
  }

  @action
  removeItem(index) {
    const items = [...this.items];
    items.splice(index, 1);
    this.emit(items);
  }

  <template>
    <div class="dwp-list-editor">
      {{#each this.items as |item index|}}
        <div class="dwp-list-editor__item">
          {{#each @fields as |field|}}
            {{#if (eq field.type "textarea")}}
              <textarea
                class="dwp-field__input dwp-field__textarea dwp-list-editor__field"
                placeholder={{field.label}}
                {{on "input" (fn this.updateField index field.key)}}
              >{{get item field.key}}</textarea>
            {{else}}
              <input
                type="text"
                class="dwp-field__input dwp-list-editor__field"
                value={{get item field.key}}
                placeholder={{field.label}}
                {{on "input" (fn this.updateField index field.key)}}
              />
            {{/if}}
          {{/each}}
          <button type="button" class="btn btn-danger btn-small dwp-list-editor__remove" {{on "click" (fn this.removeItem index)}}>
            &times;
          </button>
        </div>
      {{/each}}
      <button type="button" class="btn btn-default btn-small dwp-list-editor__add" {{on "click" this.addItem}}>
        + Add
      </button>
    </div>
  </template>
}

import { fn } from "@ember/helper";
import { get } from "@ember/helper";

function eq(a, b) {
  return a === b;
}
