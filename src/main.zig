const std = @import("std");

const qutebrowser = struct {
// The following environment variables will be set when a userscript is launched:
// QUTE_MODE: Either hints (started via hints) or command (started via command or key binding).
// QUTE_USER_AGENT: The currently set user agent, if customized.
// QUTE_FIFO: The FIFO or file to write commands to.
// QUTE_HTML: Path of a file containing the HTML source of the current page.
// QUTE_TEXT: Path of a file containing the plaintext of the current page.
// QUTE_CONFIG_DIR: Path of the directory containing qutebrowser’s configuration.
// QUTE_DATA_DIR: Path of the directory containing qutebrowser’s data.
// QUTE_DOWNLOAD_DIR: Path of the downloads directory.
// QUTE_COMMANDLINE_TEXT: Text currently in qutebrowser’s command line. Note this is only useful for userscripts spawned (e.g. via a keybinding) when qutebrowser is still in command mode. If you want to receive arguments passed to your userscript via :spawn, use the normal way of getting commandline arguments (e.g. $@ in bash or sys.argv / argparse / … in Python).
// QUTE_VERSION: The version of qutebrowser, as a string like "2.0.0". Note that this was added in v2.0.0, thus older versions can only be detected by the absence of this variable.
//
// In command mode:
// QUTE_URL: The current page URL.
// QUTE_TITLE: The title of the current page.
// QUTE_SELECTED_TEXT: The text currently selected on the page.
// QUTE_COUNT: The count from the spawn command running the userscript.
// QUTE_TAB_INDEX: The current tab’s index.
//
// In hints mode:
// QUTE_URL: The URL selected via hints.
// QUTE_CURRENT_URL: The current page URL.
// QUTE_SELECTED_TEXT: The plain text of the element selected via hints.
// QUTE_SELECTED_HTML: The HTML of the element selected via hints.
    
    const Mode = enum {
        hints,
        command,
    };
};

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    var env = try std.process.getEnvMap(gpa.allocator());
    defer env.deinit();

    const qute_mode = std.meta.stringToEnum(qutebrowser.Mode, env.get("QUTE_MODE").?).?;
    switch (qute_mode) {
        .command => {
            const html_path = env.get("QUTE_HTML").?;
            const filename = std.fs.path.basename(html_path);

            const download_dir_path = env.get("QUTE_DOWNLOAD_DIR").?;
            const download_dir = try std.fs.cwd().openDir(download_dir_path, .{});

            try std.fs.cwd().copyFile(
                html_path,
                download_dir,
                filename,
                .{},
            );
        },
        .hints => std.debug.panic("TODO: implement read-it-later for hints mode?", .{}),
    }
}

