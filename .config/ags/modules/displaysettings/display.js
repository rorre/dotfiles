import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import { MaterialIcon } from "../.commonwidgets/materialicon.js";
const { execAsync, exec } = Utils;
const { Box, EventBox, Label, Button } = Widget;
import { setupCursorHover } from "../.widgetutils/cursorhover.js";

const mirrorButton = Button({
  className: "display-setting",
  child: Box({
    hexpand: true,
    className: "spacing-h-15",
    children: [
      MaterialIcon("tv_displays", "larger"),
      Box({
        vertical: true,
        hpack: "start",
        className: "spacing-v-5",
        children: [
          Label({
            hpack: "start",
            className: "txt-small",
            label: "Duplicate",
          }),
          Label({
            className: "txt-smaller",
            label: "Duplicate the screen to HDMI port.",
          }),
        ],
      }),
    ],
  }),
  onClicked: (self) => {
    exec("hyprctl keyword monitor HDMI-A-1,preferred,auto,1,mirror,eDP-1");
    self.toggleClassName("display-settings-active", true);
    extendButton.toggleClassName("display-settings-active", false);
  },
  setup: (self) => setupCursorHover(self),
});

const extendButton = Button({
  className: "display-setting",
  child: Box({
    hexpand: true,
    className: "spacing-h-15",
    children: [
      MaterialIcon("tv_displays", "larger"),
      Box({
        vertical: true,
        hpack: "start",
        className: "spacing-v-5",
        children: [
          Label({
            hpack: "start",
            className: "txt-small",
            label: "Extend",
          }),
          Label({
            className: "txt-smaller",
            label: "Use the HDMI port as second monitor.",
          }),
        ],
      }),
    ],
  }),
  onClicked: (self) => {
    exec("hyprctl keyword monitor HDMI-A-1,highres+highrr,auto-right,1");
    self.toggleClassName("display-settings-active", true);
    mirrorButton.toggleClassName("display-settings-active", false);
  },
  setup: (self) => setupCursorHover(self),
});

export default () =>
  Box({
    vexpand: true,
    hexpand: true,
    css: "min-width: 2px;",
    children: [
      EventBox({
        onPrimaryClick: () => App.closeWindow("sideright"),
        onSecondaryClick: () => App.closeWindow("sideright"),
        onMiddleClick: () => App.closeWindow("sideright"),
      }),
      Box({
        vertical: true,
        vexpand: true,
        className: "sidebar-right spacing-v-15",
        children: [
          Label({
            label: "Display Setup",
            hpack: "start",
            className: "txt-larger txt-bold",
          }),
          extendButton,
          mirrorButton,
        ],
      }),
    ],
    setup: (self) => {
      const isExtend = !exec(`hyprctl monitors all | grep "mirrorOf: [0-9]"`);
      extendButton.toggleClassName("display-settings-active", isExtend);
      mirrorButton.toggleClassName("display-settings-active", !isExtend);
    },
  });
