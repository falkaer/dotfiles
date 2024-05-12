import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import options from "../options.js";
import GLib from "gi://GLib";

/** @param {import('types/service/notifications').Notification} n */
const NotificationIcon = ({ app_entry, app_icon, image }) => {
    if (image) {
        return Widget.Box({
            vpack: "start",
            hexpand: false,
            class_name: "icon img",
            css: `
                background-image: url("${image}");
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                min-width: 78px;
                min-height: 78px;
            `,
        });
    }

    let icon = "dialog-information-symbolic";
    if (Utils.lookUpIcon(app_icon)) icon = app_icon;

    if (Utils.lookUpIcon(app_entry || "")) icon = app_entry || "";

    return Widget.Box({
        vpack: "start",
        hexpand: false,
        class_name: "icon",
        css: `
            min-width: 78px;
            min-height: 78px;
        `,
        child: Widget.Icon({
            icon,
            size: 58,
            hpack: "center",
            hexpand: true,
            vpack: "center",
            vexpand: true,
        }),
    });
};

/** @param {import('types/service/notifications').Notification} notification */
function NotificationWidget(notification) {
    const content = Widget.Box({
        class_name: "content",
        children: [
            NotificationIcon(notification),
            Widget.Box({
                hexpand: true,
                vertical: true,
                children: [
                    Widget.Box({
                        children: [
                            Widget.Label({
                                class_name: "title",
                                xalign: 0,
                                justification: "left",
                                hexpand: true,
                                max_width_chars: 24,
                                truncate: "end",
                                wrap: true,
                                label: notification.summary,
                                use_markup: true,
                            }),
                            Widget.Label({
                                class_name: "time",
                                vpack: "start",
                                label: GLib.DateTime.new_from_unix_local(
                                    notification.time,
                                ).format("%H:%M"),
                            }),
                            Widget.Button({
                                class_name: "close-button",
                                vpack: "start",
                                child: Widget.Icon("window-close-symbolic"),
                                on_clicked: () => notification.close(),
                            }),
                        ],
                    }),
                    Widget.Label({
                        class_name: "description",
                        hexpand: true,
                        use_markup: true,
                        xalign: 0,
                        justification: "left",
                        label: notification.body,
                        wrap: true,
                    }),
                ],
            }),
        ],
    });

    const actionsbox = Widget.Revealer({
        transition: "slide_down",
        child: Widget.EventBox({
            child: Widget.Box({
                class_name: "actions horizontal",
                children: notification.actions.map((action) =>
                    Widget.Button({
                        class_name: "action-button",
                        on_clicked: () => notification.invoke(action.id),
                        hexpand: true,
                        child: Widget.Label(action.label),
                    }),
                ),
            }),
        }),
    });

    return Widget.EventBox({
        class_name: `notification ${notification.urgency}`,
        vexpand: false,
        on_primary_click: () => notification.dismiss(),
        on_hover() {
            actionsbox.reveal_child = true;
        },
        on_hover_lost() {
            actionsbox.reveal_child = true;
            notification.dismiss();
        },
        child: Widget.Box({
            vertical: true,
            children:
                notification.actions.length > 0 ? [content, actionsbox] : [content],
        }),
    });
}

/** @param {import('types/widgets/revealer').default} parent */
const Popups = (parent) => {
    const map = new Map();

    const onDismissed = (_, id, force = false) => {
        if (!id || !map.has(id)) return;

        if (map.get(id).isHovered() && !force) return;

        if (map.size - 1 === 0) parent.reveal_child = false;

        Utils.timeout(200, () => {
            map.get(id)?.destroy();
            map.delete(id);
        });
    };

    /** @param {import('types/widgets/box').default} box */
    const onNotified = (box, id) => {
        if (!id || Notifications.dnd) return;

        const n = Notifications.getNotification(id);
        if (!n) return;

        if (options.notifications.black_list.includes(n.app_name || "")) return;

        map.delete(id);
        map.set(id, NotificationWidget(n));
        box.children = Array.from(map.values()).reverse();
        Utils.timeout(10, () => {
            parent.reveal_child = true;
        });
    };

    return Widget.Box({
        vertical: true,
        // connections: [
        //     [Notifications, onNotified, "notified"],
        //     [Notifications, onDismissed, "dismissed"],
        //     [Notifications, (box, id) => onDismissed(box, id, true), "closed"],
        // ],
    });
};

/** @param {import('types/widgets/revealer').RevealerProps['transition']} transition */
const PopupList = (transition = "slide_down") =>
    Widget.Box({
        css: "padding: 1px",
        children: [
            Widget.Revealer({
                transition,
                setup: (self) => (self.child = Popups(self)),
            }),
        ],
    });

/** @param {number} monitor */
export default (monitor) =>
    Widget.Window({
        monitor,
        name: `notifications${monitor}`,
        class_name: "notifications",
        // binds: [["anchor", options.notifications.position]],
        child: PopupList(),
    });
