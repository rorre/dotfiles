import PopupWindow from "../.widgethacks/popupwindow.js";
import DisplaySettings from "./display.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
const { Box } = Widget;
import clickCloseRegion from "../.commonwidgets/clickcloseregion.js";

export default () =>
  PopupWindow({
    keymode: "on-demand",
    anchor: ["right", "top", "bottom"],
    name: "displaysettings",
    layer: "top",
    child: Box({
      children: [
        clickCloseRegion({
          name: "displaysettings",
          multimonitor: false,
          fillMonitor: "horizontal",
        }),
        DisplaySettings(),
      ],
    }),
  });
