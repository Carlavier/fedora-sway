#!/usr/bin/env python3
import glob
import os
import signal
import subprocess
import time
import i3ipc

PID_FILE = "/tmp/portrait_manager.pid"

if os.path.exists(PID_FILE):
    try:
        with open(PID_FILE) as f:
            os.kill(int(f.read().strip()), signal.SIGTERM)
            time.sleep(0.05)
    except Exception:
        pass

with open(PID_FILE, "w") as f:
    f.write(str(os.getpid()))

TARGET_OUTPUT = "HDMI-A-1"
TARGET_WORKSPACE = "S"
FILLER_APP_ID = "portrait_filler"
matches = glob.glob(os.path.expanduser("~/.wallpaper/using/filler.*"))
IMAGE_PATH = matches[0] if matches else ""
FILLER_CMD = [
    "imv",
    "-s",
    "crop",
    "-c",
    f"set window_title {FILLER_APP_ID}",
    IMAGE_PATH,
]

sway = i3ipc.Connection()
filler_proc = None


def get_node_output(node):
    curr = node
    while curr:
        if getattr(curr, "type", "") == "output":
            return getattr(curr, "name", None)
        curr = getattr(curr, "parent", None)
    return None


def get_target_windows():
    target_leaves = []
    for leaf in sway.get_tree().leaves():
        if get_node_output(leaf) != TARGET_OUTPUT:
            continue
        ws = leaf.workspace()
        if not ws or ws.name != TARGET_WORKSPACE:
            continue
        app_id = getattr(leaf, "app_id", "") or ""
        win_class = (
            (getattr(leaf, "ipc_data", {}) or {})
            .get("window_properties", {})
            .get("class", "")
        )
        is_floating = getattr(leaf, "floating", "") in ("auto_on", "user_on")

        if (
            app_id != "imv"
            and app_id != FILLER_APP_ID
            and win_class != FILLER_APP_ID
            and not is_floating
        ):
            target_leaves.append(leaf)
    return target_leaves


def sync_layout(sway_conn, event=None):
    global filler_proc

    if event and getattr(event, "container", None):
        app_id = getattr(event.container, "app_id", "") or ""
        if app_id == "imv" or app_id == FILLER_APP_ID:
            return

    time.sleep(0.05)
    windows = get_target_windows()
    count = len(windows)

    if count == 1:
        if filler_proc is None or filler_proc.poll() is not None:
            win = windows[0]
            ws = win.workspace()
            ws_name = ws.name if ws else None

            sway_conn.command(f'[con_id="{win.id}"] splitv')
            filler_proc = subprocess.Popen(FILLER_CMD)
            time.sleep(0.08)

            if ws_name:
                sway_conn.command(
                    f'[app_id="imv"] move container to workspace {ws_name}'
                )
            sway_conn.command(f'[app_id="imv"] move up')
            sway_conn.command(f'[con_id="{win.id}"] focus')

    elif count >= 2:
        if filler_proc and filler_proc.poll() is None:
            filler_proc.terminate()
            filler_proc = None

        if event and getattr(event, "container", None):
            focused_id = event.container.id
            if any(w.id == focused_id for w in windows):
                sway_conn.command(f'[con_id="{focused_id}"] move up')

    elif count == 0 and filler_proc and filler_proc.poll() is None:
        filler_proc.terminate()
        filler_proc = None


sway.on("window::new", sync_layout)
sway.on("window::close", sync_layout)
sway.on("window::move", sync_layout)

sync_layout(sway)
sway.main()
